const express = require("express");
const mysql = require("../util/mysql");
const router = express.Router();
const tool = require("../util/tool");
const formatLineToTree = require('../util/makeTreeArray');

const { batch } = tool;
const { query, dateFormat, isLeader } = mysql;

const queryDepartmentSql = `
    select
      a.id as id,
      a.super_id as superId,
      a.name as depName,
      a.leader as leaderId,
      b.user_name as leaderName,
      date_format(a.create_time, '${dateFormat}') as createdTime,
      date_format(a.last_modify_time,'${dateFormat}') as lastModifiedTime
    from
      department as a left join user as b on(a.leader = b.id)
`;

// 获取部门列表数据
router.get("/department/list", async (req, res, next) => {
  let {
    depName,
    leaderName,
    startTime,
    endTime,
    current = 1,
    pageSize = 10
  } = req.query;
  
  current = parseInt(current);
  pageSize = parseInt(pageSize);

  if (current < 0 || pageSize < 0) {
    res.status(400).json({
      code: 400,
      message: `非法的负数分页参数`,
    });
    return;
  }

  let start = pageSize * (current - 1);
  let end = start + pageSize;
  
  // 部门条数
  let sql = batch(() => {
    let sql = queryDepartmentSql;  
    if (leaderName || startTime || endTime || depName) {
      sql += ' where ';
      sql += depName ? `a.name like '%${depName}%' and ` : '';
      sql += leaderName ? `b.name like '%${leaderName}%' and ` : '';
      sql += startTime ? `a.create_time >= '${startTime}' and `: '';
      sql += endTime ? `a.create_time <= '${endTime}' and ` : '';
      sql += ';'
      // 删除最后1个无用的and
      sql = sql.replace(/and(?=\s*;)/, '');
    }
    console.log('/department/list sql:', sql);
    return sql;
  });

  try {
    let result = await query(sql) || [];
    let total = result.length;
    let pages = Math.ceil(total / pageSize);
    // 当前所有部门是同级的,都在数组中展开，没有层次关系（每个部门有自己的父部门）
    result = result.slice(start, end);
    res.status(200).json({
      code: 200,
      message: "获取部门数据成功~",
      data: result,
      total,
      pages,
      current,
      pageSize,
    });
  } catch (e) {
    console.log("获取部门数据时发生错误:", e.message);
    next(e);
  }
});

// 获取部门树形数据
router.get("/department/tree", async (req, res, next) => {
  let sql = queryDepartmentSql
  console.log("get /department/tree sql:", sql);
  try {
    let result = await query(sql);
    if (Array.isArray(result)) {
      let data = formatLineToTree(result);
      res.status(200).json({
        code: 200,
        message: "获取部门树形数据成功~",
        data
      });
    }
  } catch(e) {
    console.log("获取部门树形数据时发生了错误:", e.message);
  }
});

// 创建部门
router.post("/department", async (req, res, next) => {
  let {
    leaderId,
    name,
    superId
  } = req.body;

  if (!name) {
    res.status(400).json({
      code: 400,
      message: "必须要指定name~"
    });
    return;
  }

  let sql = await batch(async () => {
    let sql = `insert into department (name `;
    if (leaderId) {
      if (isLeader(leaderId)) {
        res.status(400).json({
          code: 400,
          message: "要添加的部长已经是其它部门的部长了~"
        });
        return 'error';
      }
    }
    sql += leaderId ? `, leader`: '';
    sql += superId ? `, super_id` : '';
    sql += `) value ('${name}'`;
    sql += leaderId ? `, '${leaderId}'`: '';
    sql += superId ? `, ${superId}` : '';
    sql += ')';
    console.log("create dep post sql:", sql);
    return sql;
  });

  if (sql === 'error') {
    return;
  }
  
  try {
    let result = await query(sql) || {};
    if (result.affectedRows === 1) {
      res.status(200).json({
        code: 200,
        message: '创建部门成功~'
      })
      return;
    }
    throw new Error();
  } catch(e) {
    console.log('创建部门时发生错误:', e.message);
    next("系统错误");
  }
});

// 更新部门
router.patch("/department/:id", async (req, res, next) => {
  let {id} = req.params;
  if (!id) {
    next();
    return
  }
  let {
    leaderId,
    name,
    superId
  } = req.body;

  let success = () => {
    res.status(200).json({
      code: 200,
      message: "更新部门成功~"
    });
  }

  if (!leaderId && !name && !superId) {
    success();
    return;
  }

  if (!!leaderId) {
    if (isLeader(leaderId, id)) {
      res.status(400).json({
        code: 400,
        message: "要添加的部长已经是其它部门的部长了~"
      });
      return;
    }
  }

  let sql = batch(() => {
    let sql = "update department set ";
    if (leaderId) {
      sql += `leader = '${leaderId}', `;
    }
    if (name) {
      sql += `name = '${name}', `
    }
    if (superId) {
      sql += `super_id = ${superId === -1 ? null : superId}, `;
    }

    sql += `last_modify_time = now() `;
    sql += ` where id = ${id};`;
    console.log('/department patch sql:', sql);
    return sql;
  });

  try {
    let result = await query(sql) || {};
    if (result.affectedRows === 1) {
      success();
    } else if (result.affectedRows === 0) {
      res.status(400).json({
        code: 400,
        message: "不存在该部门~"
      });
    } else {
      throw new Error();
    }
  } catch(e) {
    console.log("更新部门时发生错误:", e.message)
    next("系统错误");
  }
});

// 删除部门
router.delete("/department/:id", async (req, res, next) => {
  let { id } = req.params;
  if (!id) {
    next();
    return;
  }
  
  let sql = `delete from department where id = ${id}`;
  try {
    let result = await query(sql) || {};
    if (result.affectedRows === 1) {
      res.status(200).json({
        code: 200,
        message: "删除部门成功~"
      });
    } else if (result.affectedRows === 0) {
      res.status(200).json({
        code: 400,
        message: "不存在该部门~"
      });
    } else {
      throw new Error();
    }
  } catch(e) {
    console.log("删除部门时发生错误:", e);
    next("系统错误");
  }
});

// 把多个用户和部门关联
router.post("/department/relationship", async (req, res, next) => {
  let { userIds, departmentId } = req.body;
  if (!userIds || !departmentId || !Array.isArray(userIds)) {
    res.status(400).json({
      code: 400,
      message: "userIds和departmentId不能为空，并且userIds必须是数组~"
    });
    return;
  }
  
  let success = () => {
    res.status(200).json({
      code: 200,
      message: "部门添加多个用户成功~"
    });
  };

  if (userIds.length === 0)  {
    success();
    return;
  }

  let sql = batch(() => {
    let sql = `update user set department_id = ${departmentId} where id in (`;
    userIds.forEach((userId, index) => {
      sql += `'${userId}'`;
      sql += index < userIds.length - 1 ? ',' : ')';
    });
    console.log('/department/relationship post sql:', sql);
    return sql;
  });

  try {
    let result = await query(sql) || {};
    if (result.affectedRows === userIds.length) {
      success();
    } else {
      let successTotal = result.affectedRows;
      if (successTotal === 0) {
        throw new Error();
      }
      res.status(400).json({
        code: 400,
        message: `只有${successTotal}位用户关联成功~`
      });
    }
  } catch (e) {
    console.log("给部门添加用户时出错:", e.message);
    next("系统错误");
  }
});

module.exports = router;