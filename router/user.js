const express = require("express");
const mysql = require("../util/mysql");
const router = express.Router();
const tool = require("../util/tool");

const { batch,isUndef } = tool;
const { query, dateFormat, isLeader } = mysql;

// 获取用户列表
router.get("/user/list", async (req, res, next) => {
  let {
    userName,
    realName,
    cellphone,
    status,
    startTime,
    endTime,
    current = 1,
    pageSize = 10,
  } = req.query;

  current = parseInt(current);
  pageSize = parseInt(pageSize);

  if (current < 0 || pageSize < 0) {
    res.status(400).json({
      code: 400,
      message: "负数的分页参数是非法的~",
    });
    return;
  }

  let start = pageSize * (current - 1);
  let end = start + pageSize;
  // 用户条数
  let total = 0;
  
  // 生成sql语句
  let sql = batch(() => {
    let sql = `
    select
      a.id,
      b.name as roleName,
      a.user_name as userName,
      a.real_name as realName,
      a.cellphone,
      a.status,
			c.name as departmentName,
      date_format(a.create_time, '${dateFormat}') as createdTime,
      date_format(a.last_modify_time,'${dateFormat}') as lastModifiedTime
    from
      user as a left join role as b on(a.role_id = b.symbol) 
			inner join department as c on (a.department_id = c.id)
    where `;

    if (realName) {
      sql += ` a.real_name like '%${realName}%' and `;
    }
    if (userName) {
      sql += ` a.user_name like '%${userName}%' and `;
    }
    if (cellphone) {
      sql += ` a.cellphone like '%${cellphone}%' and `;
    }
    if (!isUndef(status)) {
      sql += " a.status = status and ";
    }
    if (startTime) {
      sql += ` a.create_time >= '${startTime}' and `;
    }
    if (endTime) {
      sql += ` a.create_time <= '${endTime}'`;
    }
    sql += ";";

    // 最后1个无后接条件的and
    let reg = /and(?=\s*;\s*$)/g;
    sql = sql.replace(reg, "");

    if (/where(?=\s*;)/.test(sql)) {
      console.log("ok");
      sql = sql.replace(/where(?=\s*;)/, "");
    }

    console.log("/user/list sql:", sql);
    return sql;
  });

  try {
    let result = (await query(sql)) || [];
    let total = result.length;
    let pages = Math.ceil(total / pageSize);
    result = result.slice(start, end);
    res.status(200).json({
      code: 200,
      message: "获取用户列表成功~",
      data: result,
      total,
      pages,
      current,
      pageSize
    });
  } catch (e) {
    console.log("获取用户列表时发生错误:", e.message);
    next("系统错误");
  }
});

router.get("/user/:id", async (req, res, next) => {
  let id = req.params.id;
  if (!id) {
    next();
    return;
  }
  let sql = `
    select
      a.id,
      b.name as roleName,
      b.introduction,
      a.user_name as userName,
      a.real_name as realName,
      a.cellphone,
      a.status,
      date_format(a.create_time, '${dateFormat}') as createdTime,
      date_format(a.last_modify_time,'${dateFormat}') as lastModifiedTime
    from
      user as a left join role as b on(a.role_id = b.symbol) 
    where a.id = '${id}'`;
  try {
    let result = await query(sql);
    if (result) {
      if (result[0]) {
        res.status(200).json({
          code: 200,
          message: "获取用户信息成功~",
          data: result[0]
        });
      } else {
        res.status(400).json({
          code: 400,
          message: "不存在该用户~",
        });
      }
    } else {
      throw new Error();
    }
  } catch(e) {
    console.log("获取用户信息时出错:", e.message);
    next("系统错误");
  }
});

// 创建用户
router.post("/user", async (req, res, next) => {
  let {
    userId,
    password,
    userName,
    realName,
    cellphone,
    departmentId,
    roleId,
  } = req.body;

  if (!userId || !password || !userName) {
    res.status(400).json({
      code: 400,
      message: "必须要指定userId、password和usrName~",
    });
    return;
  }

  let targetFields = [
    "id",
    "password",
    "user_name",
  ];
  let targetValues = [
    `'${userId}'`,
    `'${password}'`,
    `'${userName}'`,
  ];

  // 增加目标字段
  batch(() => {
    if (realName) {
      targetFields.push("real_name");
      targetValues.push(`'${realName}'`);
    }
    if (cellphone) {
      targetFields.push("cellphone");
      targetValues.push(`'${cellphone}'`);
    }
    if (departmentId) {
      targetFields.push("department_id");
      targetValues.push(departmentId);
    }
    if (roleId) {
      targetFields.push("role_id");
      targetValues.push(roleId);
    }
  });

  // 计算sql语句
  let sql = batch(() => {
    let sql = "insert into user(";
    targetFields.forEach((field, index) => {
      sql += field;
      if (index !== targetFields.length - 1) {
        sql += ",";
      }
    });
    sql += ") values(";

    targetValues.forEach((value, index) => {
      sql += value;
      if (index !== targetValues.length - 1) {
        sql += ",";
      }
    });
    sql += ")";
    console.log("/user, post sql:", sql);
    return sql;
  });

  try {
    let result = await query(sql) || {};
    if (result.affectedRows === 1) {
      res.status(200).json({
        code: 200,
        message: "创建用户成功~",
      });
      return;
    }
    throw new Error();
  } catch (e) {
    console.log("创建用户时发生错误:", e.message);
    if (e.message.includes("ER_DUP_ENTRY")) {
      res.status(204).json({
        code: 204,
        message: "用户已经存在~",
      });
    } else {
      next("系统错误");
    }
  }
});

// 更新用户
router.patch("/user/:id", async (req, res, next) => {
  let { id:originId } = req.params;
  if (!originId) {
    next();
    return;
  }

  let {
    userId,
    userName,
    realName,
    cellphone,
    departmentId,
    roleId,
    password,
  } = req.body;

  let success = () => {
    res.status(200).json({
      code: 200,
      message: "更新用户成功~",
    });
  };

  // 计算sql语句
  let sql = await batch(async () => {
    let sql = "update user set ";
    if (userId) {
      sql += ` id = '${userId}',`;
    }
    if (userName) {
      sql += `user_name = '${userName}',`;
    }
    if (realName) {
      sql += `real_name = '${realName}',`;
    }
    if (cellphone) {
      sql += `cellphone = '${cellphone}',`;
    }
    if (departmentId) {
      if (!isLeader(originId, departmentId)) {
        sql += `department_id = ${departmentId}, `;
      } else {
        res.status(400).json({
          code: 400,
          message: "用户已是其它部门的领导~"
        });
        return "error";
      }
    }

    if (roleId) {
      sql += `role_id = ${roleId}, `;
    }
    if (password) {
      sql += `password = '${password}',`;
    }

    // 至少更新了1个字段
    if (sql.includes(",")) {
      sql += "last_modify_time = now() ";
      sql += ` where id = '${originId}';`;
    } else {
      sql = "";
    }
    return sql;
    // console.log('/user patch sql:', sql);
  });

  if (!sql) {
    success();
    return;
  }

  if (sql === "error") {
    return;
  }
  
  try {
    let result = await query(sql) || {};
    if (result.affectedRows === 1) {
      success();
    } else if (result.affectedRows === 0) {
      res.status(204).json({
        code: 204,
        message: "不存在该用户~"
      });
    } else {
      throw new Error();
    }
  } catch (e) {
    console.log("更新用户时发生错误:", e.message);
    next("系统错误");
  }
});

// 删除用户
router.delete("/user/:id", async (req, res, next) => {
  let { id } = req.params;
  if (!id) {
    next();
    return;
  }

  let sql = `delete from user where id='${id}'`;

  try {
    let result = await query(sql) || {};
    if (result.affectedRows === 1) {
      res.status(200).json({
        code: 200,
        message: "删除用户成功~"
      });
    } else if (result.affectedRows === 0) {
      res.status(200).json({
        code: 200,
        message: "不存在该用户~"
      });
    } else {
      throw new Error();
    }
  } catch(e) {
    console.log("删除用户时发生错误:", e.message);
    next("系统错误");
  } 
});

module.exports = router;