const express = require("express");
const mysql = require("../util/mysql");
const router = express.Router();
const tool = require("../util/tool");
const permissionTool = require("../util/permission");

const { batch, isUndef } = tool;
const { query, dateFormat } = mysql;
const { hasInvalidPermission } = permissionTool;

// 获取角色列表
router.get("/role/list", async(req, res, next) => {
  let {
    name,
    introduction,
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
      message: `负数的分页参数是非法的~`,
    });
    return;
  }

  let start = pageSize * (current - 1);
  let end = start + pageSize;
  // 角色条数
  let total = 0;
  
  // 生成sql语句
  let sql = batch(() => {
    let sql = `
      select
        symbol as id,
        name,
        introduction,
        permissions,
        date_format(create_time, '${dateFormat}') as  createdTime,
        date_format(last_modify_time, '${dateFormat}') as lastModifiedTime
      from role where 
    `;

    if (name) {
      sql += ` name like '%${name}%' and `;
    }
    if (introduction) {
      sql += ` introduction like '%${introduction}%' and `;
    }
    if (startTime) {
      sql += ` create_time >= '${startTime}' and `;
    }
    if (endTime) {
      sql += ` create_time <= '${endTime}'`;
    }
    sql += ";";

    // 最后1个无后接条件的and
    let reg = /and(?=\s*;\s*$)/g;
    sql = sql.replace(reg, "");

    // 没有查询条件的情况下
    // 注：sql语句没有limit限制，因为需要获取此条件的查询总数
    // 这样不需要额外的sql语句, 数量的限制在下面
    if (!name && !introduction && !startTime && !endTime) {
      sql = sql.replace(/where(?=\s*;)/, "");
    }
    console.log('/role/list sql:', sql);
    return sql;
  });

  try {
    let result = (await query(sql)) || [];
    let total = result.length;
    let pages = Math.ceil(total / pageSize);
    result = result.slice(start, end);
    res.status(200).json({
      code: 200,
      message: "获取角色列表成功~",
      data: result,
      total,
      pages,
      current,
      pageSize
    });
  } catch (e) {
    console.log("获取角色列表时发生错误:", e.message);
    next("系统错误");
  }
});

// 创建角色
router.post("/role", async (req, res, next) => {
  let {
    name,
    permissions,
    introduction
  } = req.body;
  
  if (!name || !Array.isArray(permissions)) {
		console.log('test role');
    res.status(400).json({
      code: 400,
      message: "name不能为空, permissions必须是数组~"
    });
    return;
  }

  permissions = permissions.map((p) => parseInt(p));

  if (hasInvalidPermission(permissions)) {
    res.status(400).json({
      code: 403,
      message: "非法的权限列表~"
    });
    return;
  }

  let sql = batch(() => {
    let sql = 'insert into role(name, permissions';
    if (introduction) {
      sql += ',introduction';
    };
    let ps = permissions.join(',');
    sql += `) values ('${name}', '${ps}'`;
    if (introduction) {
      sql += `, '${introduction}'`
    }
    sql += ')';
    console.log('post create role sql:', sql);
    return sql;
  });
  
  try {
    let result = await query(sql) || {};
    if (result.affectedRows === 1) {
      res.status(200).json({
        code: 200,
        message: "创建角色成功~"
      });
      return;
    }
    throw new Error();
  } catch(e) {
    console.log("创建角色时发生错误:", e.message);
    next("系统错误");
  }
});

// 更新角色
router.patch("/role/:id", async (req, res, next) => {
  let { id } = req.params;
  if (!id) {
    next();
    return;
  }

  let {
    name,
    introduction,
    permissions
  } = req.body;

  let success = () => {
    res.status(200).json({
      code: 200,
      message: "更新角色成功~",
    });
  }

  if (Array.isArray(permissions)) {
    if (hasInvalidPermission(permissions)) {
      res.status(400).json({
        code: 403,
        message: "非法的权限列表~"
      });
      return;
    }
  }

  // 计算sql语句
  let sql = batch(() => {
    let sql = "update role set ";
    if (name) {
      sql += ` name = '${name}',`;
    }
    if (introduction) {
      sql += `introduction = '${introduction}',`;
    }
    if (permissions) {
      sql += `permissions = '${permissions.join(',')}' ,`
    }

    // 至少更新了1个字段
    if (sql.includes(",")) {
      sql += `last_modify_time = now() `;
      sql += ` where symbol = ${id};`;
    } else {
      sql = '';
    }
    console.log('/role patch sql:', sql);
    return sql;
  });

  if (!sql) {
    success();
    return;
  }

  try {
    let result = await query(sql) || {};
    if (result.affectedRows === 1) {
      success();
    } else if (result.affectedRows === 0) {
      res.status(400).json({
        code: 400,
        message: "不存在该角色~"
      });
    } else {
      throw new Error();
    }
  } catch (e) {
    console.log("更新角色时发生错误:", e.message);
    next("系统错误");
  }
});

// 删除角色
router.delete("/role/:id", async (req, res, next) => {
  let id = req.params.id;
  if (!id) {
    next();
    return;
  }

  let sql = `delete from role where symbol=${id}`;

  try {
    let result = await query(sql) || {};
    if (result.affectedRows === 1) {
      res.status(200).json({
        code: 200,
        message: '删除角色成功~'
      });
    } else if (result.affectedRows === 0) {
      res.status(200).json({
        code: 204,
        message: '不存在该角色~'
      });
    } else {
      throw new Error();
    }
  } catch(e) {
    console.log("删除角色时发生错误:", e.message);
    next("系统错误");
  } 
})

module.exports = router;