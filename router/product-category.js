const express = require("express");
const mysql = require("../util/mysql");
const router = express.Router();
const tool = require("../util/tool");

const { batch, isUndef } = tool;
const { query, dateFormat } = mysql;

// 获取商品分类列表
router.get("/product/category/list", async(req, res, next) => {
  let {
    name,
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
      message: `负数的分页参数是非法的~`,
    });
    return;
  }

  let start = pageSize * (current - 1);
  let end = start + pageSize;
  // 商品分类条数
  let total = 0;
  
  // 生成sql语句
  let sql = batch(() => {
    let sql = `
      select
        id, name,
        date_format(create_time, '${dateFormat}') as createdTime,
        date_format(last_modify_time, '${dateFormat}') as lastModifiedTime
      from product_category
      where `
    ;
    sql += name ? ` name like '%${name}%' and ` : '';
    sql += startTime ? ` create_time >= '${startTime}' and ` : '';
    sql += endTime ? ` create_time <= '${endTime}' and ` : '';
    sql += ";";

    // 最后1个无后接条件的and
    let reg = /and(?=\s*;\s*$)/g;
    sql = sql.replace(reg, "");

    // 没有查询条件时
    if (!name && !startTime && !endTime) {
      sql = sql.replace(/where(?=\s*;)/, "");
    }
    console.log('get /product/category/list sql:', sql);
    return sql;
  });

  try {
    let result = (await query(sql)) || [];
    let total = result.length;
    let pages = Math.ceil(total / pageSize);
    result = result.slice(start, end);
    res.status(200).json({
      code: 200,
      message: "获取商品分类列表成功~",
      data: result,
      total,
      pages,
      current,
      pageSize
    });
  } catch (e) {
    console.log("获取商品分类列表时发生错误:", e.message);
    next("系统错误");
  }
});

// 创建商品分类
router.post("/product/category", async (req, res, next) => {
  let { name } = req.body;
  
  if (!name) {
    res.status(400).json({
      code: 400,
      message: "name不能为空~"
    });
    return;
  }

  let sql = `insert into product_category (name) value('${name}')`;
  console.log('post create product_category sql:', sql);
  
  try {
    let result = await query(sql) || {};
    if (result.affectedRows === 1) {
      res.status(200).json({
        code: 200,
        message: "创建商品分类成功~"
      });
      return;
    }
    throw new Error();
  } catch(e) {
    console.log("创建商品分类时发生错误:", e.message);
    next("系统错误");
  }
});

// 更新商品分类
router.patch("/product/category/:id", async (req, res, next) => {
  let { id } = req.params;
  if (!id) {
    next();
    return;
  }

  let { name } = req.body;

  let success = () => {
    res.status(200).json({
      code: 200,
      message: "更新商品分类成功~",
    });
  }

  if (!name) {
    success();
    return;
  }

  let sql = `update product_category set name='${name}', last_modify_time=now() where id =${id}`;
  console.log('/product_category patch sql:', sql);

  try {
    let result = await query(sql) || {};
    if (result.affectedRows === 1) {
      success();
      return;
    } else if (result.affectedRows === 0) {
      res.status(400).json({
        code: 400,
        message: "不存在该商品分类"
      })
    } else {
      throw new Error();
    }
  } catch (e) {
    console.log("更新商品分类时发生错误:", e.message);
    next("系统错误");
  }
});

// 删除商品分类
router.delete("/product/category/:id", async (req, res, next) => {
  let id = req.params.id;
  if (!id) {
    next();
    return;
  }

  let sql = `delete from product_category where id=${id}`;
  console.log('product_category delete sql:', sql);

  try {
    let result = await query(sql) || {};
    if (result.affectedRows === 1) {
      res.status(200).json({
        code: 200,
        message: '删除商品分类成功~'
      });
    } else if (result.affectedRows === 0) {
      res.status(200).json({
        code: 200,
        message: '不存在该商品分类~'
      });
    } else {
      throw new Error();
    }
  } catch(e) {
    console.log("删除商品分类时发生错误:", e.message);
    next("系统错误");
  } 
})

module.exports = router;