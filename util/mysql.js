const mysql = require("mysql");

// 创建连接池
const pool = mysql.createPool({
  host: "localhost",
  user: "root",
  password: "123456",
  database: "bs_admin",
  port: 3306,
});

//创建查询方法
const query = (sql) => {
  return new Promise((resolve, reject) => {
    pool.getConnection((err, connection) => {
      if (err) {
        reject(err);
        return;
      }
      connection.query(sql, (err, result) => {
        if (err) {
          reject(err);
        }
        else {
          resolve(result);
        }
        connection.release();
      });
    });
  });
};

// 根据superid查找路由
const queryPermissionsWithSuperId = async (superId) => {
  try {
    let sql = `select * from permission where superId = ${superId}`;
    let res = await query(sql);
    let permissionObj = {};
    if (res && Array.isArray(res)) {
      return res;
    }
    throw new Error();
  }
  catch (e) {
    return null;
  }
};

const dateFormat = "%Y-%m-%d %T";
const dateFormat2 = "%Y-%m-%d";
// 查找部门领导
const isLeader = async (id, dep) => {
  let sql = `select count(id) as flag from department where leader='${id}' and id != ${dep || null} `;
  try {
    let result = await query(sql);
    return !!(result && result[0] && result[0].flag >= 1);
  } catch (e) {
    console.log("判断用户是否是部门的部长时出错:", e.message);
    return false;
  }
};

module.exports = {
  query,
  dateFormat,
	dateFormat2,
  isLeader,
  queryPermissionsWithSuperId,
};

//其实都没有`
