const express = require("express")
const mysql = require('../util/mysql')
const router = express.Router();
const tool = require('../util/tool')

const { batch, isUndef } = tool
const { query, dateFormat } = mysql

// 获取假期数据
router.get("/attendance/business/list", async (req, res, next) => {
  let {
		user_id,
		user_name,
		department,
		reason,
		status,
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
       b.id,
       a.user_name as userName,
       a.real_name as realName,
			 b.user_id,
       b.reason,
       date_format(b.start, '${dateFormat}') as start,
       date_format(b.end, '${dateFormat}') as end,
			 b.status,
			 c.name as department,
       date_format(b.create_time, '${dateFormat}') as createdTime,
       date_format(b.update_time,'${dateFormat}') as updateTime
     from 
       user as a inner join schedule as b on (a.id = b.user_id)
			 inner join department as c on (a.department_id = c.id)
     where b.type = '1' and
      `
		
		if (user_id) {
		  sql += ` b.user_id = '${user_id}' and `;
		}
		if (user_name) {
		  sql += ` a.user_name = '%${user_name}%' and `;
		}
		if (reason) {
		  sql += ` b.reason like '%${reason}%' and `;
		}
		if(department){
			sql += ` a.department_id = '${department}' and `;
		}
		if(status){
			sql += ` b.status = '${status}' and`
		}
   sql += ";";

    // 最后1个无后接条件的and
    let reg = /and(?=\s*;\s*$)/g;
    sql = sql.replace(reg, "");

    if (/where(?=\s*;)/.test(sql)) {
      console.log("ok");
      sql = sql.replace(/where(?=\s*;)/, "");
    }
		console.log(sql);
		return sql;
  })
  try {
    let result = (await query(sql)) || [];
    let total = result.length;
    let pages = Math.ceil(total / pageSize);
    result = result.slice(start, end);
    res.status(200).json({
      code: 200,
      message: "获取出差列表成功~",
      data: result,
      total,
      pages,
      current,
      pageSize
    });
  } catch (e) {
    console.log("获取出差列表时发生错误:", e.message);
    next("系统错误");
  }
})

// 新增假期数据
router.post("/attendance/business", async (req, res, next) => {
  let {
		reason,
		start,
		end,
		user_id,
  } = req.body
	if(!reason || !start || !end){
		res.status(400).json({
		  code: 400,
		  message: "出差原因，开始和结束时间都不能为空！"
		});
		return;
	}
	let checkSql = `select id from schedule where 
									 reason = '${reason}' and 
									 start = '${start}' and 
									 end = '${end}'  and type = '1' and status = 0`
	try {
	  let result = await query(checkSql) || {};
		console.log(result,'check');
	  if (result.length !== 0) {
	    res.status(400).json({
	      code: 3,
	      message: "出差申请已存在,请勿重复申请！"
	    });
	    return;
	  }
	} catch(e) {
	  next("系统错误");
		return
	}
	
	
  // 生成sql语句
  let sql = batch(() => {
    let sql = `
      insert into schedule(reason,start,end,status,type,user_id) 
			      values ('${reason}','${start}','${end}','${0}','${1}','${user_id}') 
      `
    return sql;
  })
  try {
    let result = await query(sql) || {};
    if (result.affectedRows === 1) {
      res.status(200).json({
        code: 200,
        message: "出差申请成功~"
      });
      return;
    }
    throw new Error();
  } catch(e) {
    console.log("出差申请时发生错误:", e.message);
    next("系统错误");
  }
})

// 批准和不批准请假
router.patch("/attendance/business/:id", async (req, res, next) => {
  let { id } = req.params;
  if (!id) {
    next();
    return;
  }
  
	let {
		status	
  } = req.body
	console.log('相应数据');
  // 生成sql语句
  let sql = batch(() => {
    let sql = `
      update schedule set status = '${status}' where id = '${id}';`
    return sql;
  })
  try {
    let result = await query(sql) || {};
    if (result.affectedRows === 1) {
			res.status(200).json({
				code: 200,
				message: "批准成功！",
			});
    }else if (result.affectedRows === 0) {
      res.status(400).json({
        code: 0,
        message: "批准出错~"
      });
    } else {
      throw new Error();
    }
  } catch(e) {
    console.log("批准请假时发生错误:", e.message);
    next("系统错误");
  }
})

// 删除假期
router.delete("/attendance/business/:id", async (req, res, next) => {
  let id = req.params.id;
  if (!id) {
    next();
    return;
  }

  let sql = `delete from schedule where id=${id}`;

  try {
    let result = await query(sql) || {};
    if (result.affectedRows === 1) {
      res.status(200).json({
        code: 0,
        message: '撤销申请成功~'
      });
    } else if (result.affectedRows === 0) {
      res.status(200).json({
        code: 0,
        message: '不存在申请~'
      });
    } else {
      throw new Error();
    }
  } catch(e) {
    console.log("撤销申请时发生错误:", e.message);
    next("系统错误");
  } 
})

module.exports = router;
