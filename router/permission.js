const express = require("express");
const mysql = require("../util/mysql");
const router = express.Router();
const formatLineToTree = require('../util/makeTreeArray');

const { query, dateFormat  } = mysql;

const queryAllPermission = async () => {
  let sql = `
    select
      id,
      superId,
      name,
      url,
			icon,
      button,
      status,
      date_format(create_time, '${dateFormat}') as createdTime,
      date_format(last_modify_time, '${dateFormat}') as lastModifiedTime
    from permission;
  `;

  try {
    let result = await query(sql);
    if (Array.isArray(result)) {
      return result;
    }
    throw new Error();
  } catch(e) {
    console.log('查询所有权限时出错:', e.message);
    return [];
  }
}

// 获取全部权限数据
router.get('/permission/tree', async (req, res, next) => {
  let treeData = formatLineToTree(await queryAllPermission());
  res.status(200).json({
    code: 200,
    message: "获取权限数据成功~",
    data: treeData
  });
});

// 获取当前用户拥有的权限
router.get('/permission/view', async (req, res, next) => {
  let allPermissions = await queryAllPermission();
  let { permissions } = req.body.authorization;
  // let permissions = [3,4,301,302,401,402, 30101,30102, 40202, 40201];
  let result = permissions.map((id) => allPermissions.find((permission) => permission.id == id)).filter((item) => !!item);
  result = formatLineToTree(result);
  res.status(200).json({
    code: 200,
    message: "获取权限数据成功~",
    data: result
  });
});

module.exports = router;