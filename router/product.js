const express = require("express");
const mysql = require("../util/mysql");
const router = express.Router();
const tool = require("../util/tool");

const { batch, isUndef } = tool;
const { query, dateFormat } = mysql;

// 获取商品列表
router.get("/product/list", async(req, res, next) => {
  let {
    name,
    categoryName,
    status,
    startTime,
    endTime,
    price,
    lowestPrice,
    highestPrice,
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
  // 商品条数
  let total = 0;
  
  // 生成sql语句
  let sql = batch(() => {
    let sql = `
      select
        a.id,
        a.name,
        a.url,
        a.introduction,
        b.name as categoryName,
        a.status,
        a.origin_price as originPrice,
        a.current_price as currentPrice,
        date_format(a.create_time, '${dateFormat}') as  createdTime,
        date_format(a.last_modify_time, '${dateFormat}') as lastModifiedTime
      from product as a left join product_category as b on(a.category = b.id)
      where
    `;

    if (name) {
      sql += ` a.name like '%${name}%' and `;
    }
    if (categoryName) {
      sql += ` b.name like '%${categoryName}%' and `;
    }
    if (!isUndef(status)) {
      sql += `a.status = ${status} and `;
    }
    if (startTime) {
      sql += ` a.create_time >= '${startTime}' and `;
    }
    if (endTime) {
      sql += ` a.create_time <= '${endTime}' and `;
    }
    if (!isUndef(lowestPrice)) {
      sql += ` a.current_price >= ${lowestPrice} and `;
    }
    if(!isUndef(highestPrice)) {
      sql += `a.current_price <= ${highestPrice}`
    }
    sql += ";";

    // 最后1个无后接条件的and
    let reg = /and(?=\s*;\s*$)/g;
    sql = sql.replace(reg, "");

    // 没有查询条件时
    if (!name && !categoryName && !startTime && !endTime && isUndef(status) && isUndef(lowestPrice) && isUndef(highestPrice)) {
      sql = sql.replace(/where(?=\s*;)/, "");
    }
    console.log('/product/list sql:', sql);
    return sql;
  });

  try {
    let result = (await query(sql)) || [];
    let total = result.length;
    let pages = Math.ceil(total / pageSize);
    result = result.slice(start, end);
    res.status(200).json({
      code: 200,
      message: "获取商品列表成功~",
      data: result,
      total,
      pages,
      current,
      pageSize
    });
  } catch (e) {
    console.log("获取商品列表时发生错误:", e.message);
    next("系统错误");
  }
});

// 创建商品
router.post("/product", async (req, res, next) => {
  let {
    name,
    category,
    originPrice,
    currentPrice,
    introduction,
    url,
    status
  } = req.body;
  
  if (!name || isUndef(originPrice)) {
    res.status(400).json({
      code: 400,
      message: "name和originPrice不能为空~"
    });
    return;
  }

  let sql = batch(() => {
    let sql = 'insert into product (name, origin_price, current_price';
    sql += category ? ',category' : '';
    sql += url ? ', url' : '';
    sql += !isUndef(status) ? ', status': '';
    sql += introduction ? ', introduction' : '';

    sql += `) values ('${name}', ${originPrice}, ${!isUndef(currentPrice) ? currentPrice : originPrice}`;
    sql += category ? `, ${category}` : '';
    sql += url ? `, '${url}'` : '';
    sql += !isUndef(status) ? `, ${status}` : '';
    sql += introduction ? `, '${introduction}'` : '';
    sql += ')';

    console.log('post create product sql:', sql);
    return sql;
  });
  
  try {
    let result = await query(sql) || {};
    if (result.affectedRows === 1) {
      res.status(200).json({
        code: 200,
        message: "创建商品成功~"
      });
      return;
    }
    throw new Error();
  } catch(e) {
    console.log("创建商品时发生错误:", e.message);
    next("系统错误");
  }
});

// 更新商品
router.patch("/product/:id", async (req, res, next) => {
  let { id } = req.params;
  if (!id) {
    next();
    return;
  }

  let {
    name,
    category,
    originPrice,
    currentPrice,
    status,
    introduction
  } = req.body;

  let success = () => {
    res.status(200).json({
      code: 200,
      message: "更新商品成功~",
    });
  }

  // 计算sql语句
  let sql = batch(() => {
    let sql = "update product set ";
    sql += name ? ` name = '${name}',` : '';
    sql += !isUndef(status) ? `status = ${status},` : '';
    sql += category ? ` category = ${category} ,` : '';
    sql += originPrice ? ` origin_price = ${originPrice}, ` : '';
    sql += currentPrice ? ` current_price = ${currentPrice} ,` :  '';
    sql += introduction ? ` introduction = '${introduction}', `: '';
    // 至少更新了1个字段
    if (sql.includes(",")) {
      sql += `last_modify_time = now() where id = ${id}`;
    } else {
      sql = '';
    }
    console.log('/product patch sql:', sql);
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
      return;
    } else if (result.affectedRows === 0) {
      res.status(400).json({
        code: 400,
        message: "不存在该商品~"
      })
    } else {
      throw new Error();
    }
  } catch (e) {
    console.log("更新商品时发生错误:", e.message);
    next("系统错误");
  }
});

// 删除商品
router.delete("/product/:id", async (req, res, next) => {
  let id = req.params.id;
  if (!id) {
    next();
    return;
  }

  let sql = `delete from product where id=${id}`;

  try {
    let result = await query(sql) || {};
    if (result.affectedRows === 1) {
      res.status(200).json({
        code: 200,
        message: '删除商品成功~'
      });
    } else if (result.affectedRows === 0) {
      res.status(200).json({
        code: 200,
        message: '不存在该商品~'
      });
    } else {
      throw new Error();
    }
  } catch(e) {
    console.log("删除商品时发生错误:", e.message);
    next("系统错误");
  } 
})

module.exports = router;