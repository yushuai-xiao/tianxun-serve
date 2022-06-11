const express = require("express")
const mysql = require('../util/mysql')
const router = express.Router();
const tool = require('../util/tool')

const { batch, isUndef } = tool
const { query, dateFormat } = mysql

// 获取假期数据
router.get("/attendance/holiday/list", async (req, res, next) => {
  let {
		remark,
    current = 1,
    pageSize = 10
  } = req.query

  current = parseInt(current)
  pageSize = parseInt(pageSize)

  if (current < 0 || pageSize < 0) {
    res.status(400).json({
      code: 3,
      message: `负数的分页参数是非法的~`,
    });
    return;
  }

  // 分页
  let start = pageSize * (current - 1);
  let end = start + pageSize;

  // 总条数
  let total = 0
  // 生成sql语句
  let sql = batch(() => {
    let sql = `
      select 
        id,
				time,
				date_format(start_time, '${dateFormat}') as start_time,
				date_format(end_time, '${dateFormat}') as end_time,
				remark,
        date_format(create_time, '${dateFormat}') as createdTime,
        date_format(update_time,'${dateFormat}') as updateTime
      from 
        holiday
      where 
      `
		
		if (remark) {
		  sql += ` reamrk like '%${reamrk}%' and `;
		}
    sql += ";";

    // 最后1个无后接条件的and
    let reg = /and(?=\s*;\s*$)/g;
    sql = sql.replace(reg, "");

    if (/where(?=\s*;)/.test(sql)) {
      console.log('ok');
      sql = sql.replace(/where(?=\s*;)/, "");
    }
    return sql;
  })
  try {
    let result = (await query(sql)) || [];
    let total = result.length;
    let pages = Math.ceil(total / pageSize);
    result = result.slice(start, end);
    res.status(200).json({
      code: 0,
      message: "获取假期列表成功~",
      data: result,
      total,
      pages,
      current,
      pageSize
    });
  } catch (e) {
    console.log("获取假期列表时发生错误:", e.message);
    next("系统错误");
  }
})

// 新增假期数据
router.post("/attendance/holiday", async (req, res, next) => {
  let {
		time,
		remark,
		start_time,
		end_time
  } = req.body
	if(!remark || !start_time || !end_time){
		res.status(400).json({
		  code: 3,
		  message: "remark,start_time,end_time都不能为空！"
		});
		return;
	}
	let checkSql = `select id from holiday where start_time = '${start_time}'`
	try {
	  let result = await query(checkSql) || {};
		console.log(result,'check');
	  if (result.length !== 0) {
	    res.status(400).json({
	      code: 3,
	      message: "假期已存在,无需在添加！"
	    });
	    return;
	  }
	  throw new Error();
	} catch(e) {
	  next("系统错误");
	}
	
	
  // 生成sql语句
  let sql = batch(() => {
    let sql = `
      insert into holiday(time,remark,start_time,end_time) 
			      values ('${time}','${remark}','${start_time}','${end_time}') 
      `
    return sql;
  })
  try {
    let result = await query(sql) || {};
    if (result.affectedRows === 1) {
      res.status(200).json({
        code: 0,
        message: "创建假期成功~"
      });
      return;
    }
    throw new Error();
  } catch(e) {
    console.log("创建假期时发生错误:", e.message);
    next("系统错误");
  }
})

// 修改假期数据
router.patch("/attendance/holiday/:id", async (req, res, next) => {
  let { id } = req.params;
  if (!id) {
    next();
    return;
  }
  
	let {
		time,
		remark,
		start_time,
		end_time
  } = req.body
	if(!remark || !start_time || !end_time){
		res.status(400).json({
		  code: 3,
		  message: "remark,start_time,end_time都不能为空！"
		});
		return;
	}
  // 生成sql语句
  let sql = batch(() => {
    let sql = `
      update holiday set 
			time = '${time}',remark = '${remark}',
			start_time = '${start_time}' ,end_time = '${end_time}'
      ,update_time = now() where id = '${id}';`
    return sql;
  })
  try {
    let result = await query(sql) || {};
    if (result.affectedRows === 1) {
     res.status(200).json({
       code: 0,
       message: "更新假期成功~",
     });
    }else if (result.affectedRows === 0) {
      res.status(400).json({
        code: 0,
        message: "不存在该假期~"
      });
    } else {
      throw new Error();
    }
  } catch(e) {
    console.log("更新假期时发生错误:", e.message);
    next("系统错误");
  }
})

// 删除假期
router.delete("/attendance/holiday/:id", async (req, res, next) => {
  let id = req.params.id;
  if (!id) {
    next();
    return;
  }

  let sql = `delete from holiday where id=${id}`;

  try {
    let result = await query(sql) || {};
    if (result.affectedRows === 1) {
      res.status(200).json({
        code: 0,
        message: '删除假期成功~'
      });
    } else if (result.affectedRows === 0) {
      res.status(200).json({
        code: 0,
        message: '不存在该假期~'
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
