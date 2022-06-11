const express = require("express");
const mysql = require("../util/mysql");
const router = express.Router();
const tool = require("../util/tool");

const { batch, isUndef } = tool;
const { query, dateFormat ,dateFormat2} = mysql;

// 获取用户的工作记录列表
router.get("/attendance/work/list", async (req, res, next) => {
  let {
		user_id,
    userName,
    realName,
    time,
    type,
		remark,
		department,
    current = 1,
    pageSize = 10
  } = req.query;

  current = parseInt(current);
  pageSize = parseInt(pageSize);

  if (current < 0 || pageSize < 0) {
    res.status(400).json({
      code: 3,
      message: "负数的分页参数是非法的~",
    });
    return;
  }

  // 分页
  let start = pageSize * (current - 1);
  let end = start + pageSize;

  // 总条数
  let total = 0;
  // 生成sql语句
  let sql = batch(() => {
    let sql = `
      select 
        a.id,
        a.user_name as userName,
        a.real_name as realName,
				date_format(b.date, '${dateFormat2}') as date,
				b.id as work_id,
        b.type,
        b.start,
        b.end,
        b.start_check,
        b.end_check,
        b.work_time,
        b.remark,
				c.name as department,
        date_format(a.create_time, '${dateFormat}') as createdTime,
        date_format(a.last_modify_time,'${dateFormat}') as updateTime
      from 
        user as a inner join work_check as b on (a.id = b.user_id)
				inner join department as c on (a.department_id = c.id)
      where 
      `;
		
		if (user_id) {
		  sql += ` a.id like '%${user_id}%' and `;
		}
    if (realName) {
      sql += ` a.real_name like '%${realName}%' and `;
    }
    if (userName) {
      sql += ` a.user_name like '%${userName}%' and `;
    }
    if (time) {
      sql += ` b.date = '${time}' and `;
    }
    if (type) {
      sql += ` b.type = '${type}'`;
    }
		if (remark) {
		  sql += ` b.remark = '${remark}'`;
		}
		if(department){
			sql += `c.id = '${department}' and`;
		}
    sql += ";";

    // 最后1个无后接条件的and
    let reg = /and(?=\s*;\s*$)/g;
    sql = sql.replace(reg, "");

    if (/where(?=\s*;)/.test(sql)) {
      console.log("ok");
      sql = sql.replace(/where(?=\s*;)/, "");
    }
    return sql;
  });
  try {
    let result = (await query(sql)) || [];
    let total = result.length;
    let pages = Math.ceil(total / pageSize);
    result = result.slice(start, end);
    res.status(200).json({
      code: 200,
      message: "获取工作列表成功~",
      data: result,
      total,
      pages,
      current,
      pageSize
    });
  } catch (e) {
    console.log("获取工作列表时发生错误:", e.message);
    next("系统错误");
  }
});

// 新增工作记录
router.post("/attendance/work", async (req, res, next) => {
  let {
		date,
		type,
		start,
		end,
		start_check,
		end_check,
		work_time,
		remark,
		user_id
  } = req.body
	if(!date || !type || !user_id){
		res.status(400).json({
		  code: 3,
		  message: "date,type,user_id都不能为空！"
		});
		return;
	}
	let checkSql = `select id from work_check where date = '${date}' and user_id = '${user_id}'`
	try {
	  let result1 = await query(checkSql) || {};
		console.log(result1,'check');
	  if (result1.length !== 0) {
	    res.status(200).json({
	      code: 204,
	      message: "您已打过卡了"
	    });
	    return;
	  }
	} catch(e) {
	  next("系统错误");
		return;
	}
	
	
  // 生成sql语句
  let sql = batch(() => {
    let sql = `
      insert into work_check(date,type,start,end,start_check,end_check,work_time,remark,user_id) 
			      values ('
						${date}','${type}','${start}',
						'${end}','${start_check}',
						'${end_check}','${work_time}'
						,'${remark}','${user_id}') 
      `
    return sql;
  })
  try {
    let result = await query(sql) || {};
		console.log(result);
    if (result.affectedRows === 1) {
      res.status(200).json({
        code: 200,
        message: "上班打卡成功~"
      });
      return;
    }
    throw new Error();
  } catch(e) {
    console.log("增加工作记录时发生错误:", e.message);
    next("系统错误");
  }
})

// 下班打卡
router.patch("/attendance/work", async (req, res, next) => {
  let {
		work_id,
		end_check,
		work_time
  } = req.body
	
	if(!work_id || !end_check || !work_time){
		res.status(400).json({
		  code: 3,
		  message: "参数都不能为空！"
		});
		return;
	}
  // 生成sql语句
  let sql = batch(() => {
    let sql = `
      update work_check set end_check = '${end_check}',
			 work_time = '${work_time}' where id = '${work_id}'
      `
    return sql;
  })
  try {
    let result = await query(sql) || {};
		console.log(result);
    if (result.affectedRows === 1) {
      res.status(200).json({
        code: 200,
        message: "下班打卡成功，今天辛苦了哦~"
      });
      return;
    }
    throw new Error();
  } catch(e) {
    console.log("下班打卡时发生错误:", e.message);
    next("系统错误");
  }
})

// 获取工作配置列表：后期加上定位（经纬度）
router.get("/attendance/work/config", async (req, res, next) => {
	
	const sql = "select * from config where id = '101';";
 
  try {
    let result = (await query(sql)) || [];
    res.status(200).json({
      code: 200,
      message: "获取工作时间配置成功~",
      data: result,
    });
  } catch (e) {
    console.log("获取工作配置时发生错误:", e.message);
    next("系统错误");
  }
});

// 修改工作时间配置
router.patch("/attendance/work/config", async (req, res, next) => {
	
	let {
		start,
		end
	} = req.body;
	
	if(!start || !end){
		res.status(400).json({
		  code: 400,
		  message: "上班时间和下班时间必须同时配置哦！",
		});
		return;
	}
	
	const sql = `update config set start = '${start}', end = '${end}' where id = '101';`;
 
  try {
    let result = (await query(sql)) || [];
    res.status(200).json({
      code: 200,
      message: "工作时间配置成功!",
    });
  } catch (e) {
    console.log("获取工作配置时发生错误:", e.message);
    next("系统错误");
  }
});

module.exports = router;
