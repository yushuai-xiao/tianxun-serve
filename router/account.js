const express = require("express");
const mysql = require("../util/mysql");
const JwtUtil = require("../util/token");

const router = express.Router();

const { query } = mysql;

router.post('/account/validate/:id', async (req, res, next) => {
  let id = req.params.id;
  if (!id) {
    next();
    return;
  }

  let sql = `select count(id) as total from user where id='${id}'`;
  try {
    let result = await query(sql);
    if (result && result[0]) {
      let empty = result[0].total === 0;
      res.status(200).json({
        code: 200,
        message: empty ? '账号不存在~' : '账号已经存在了~',
        data: { empty }
      });
      return;
    }
    throw new Error();
  } catch(e) {
    console.log("验证账号是否存在时出错:", e.message);
    next("系统错误");
  }  
}) 

router.post('/account', async (req, res) => {
  let {account, password} = req.body;
  let validateSql = `
    select
      b.permissions,
      a.id,
      a.status
    from user as a left join role as b on (a.role_id = b.symbol)
    where a.id='${account}' and a.password='${password}'
  `;

  try {
    let result = await query(validateSql) || [];
    if (!result[0]) {
      throw new Error('账号或密码错误');
    }
    if (result[0].status === 0) {
      res.status(400).json({
        code: 400,
        message: "账号已被禁用,请联系管理员~"
      });
      return;
    }
    let permissions = !!result[0].permissions ? result[0].permissions.split(',') : [];
    let token = JwtUtil.genarteToken(permissions);
    res.status(200).json({
      code: 200,
      message: "登录成功~",
      token,
      id: result[0].id
    });
  } catch(e) {
    console.log('登录时发生错误:', e.message);
    res.status(400).json({
      code: 400,
      message: "账号或密码错误~"
    });
  }
});



module.exports = router;