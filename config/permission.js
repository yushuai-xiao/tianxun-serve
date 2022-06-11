const mysql = require('../util/mysql');
const tool = require('../util/tool');

const {query} = mysql;
const {batch} = tool;

// 路由前缀 映射到 页面权限码
const URL_MAP_PAGE_PERMISSION = new Map([
  ["/overview", 101],
  ["/dashboard", 102],
  ["/user", 201],
  ["/department", 202],
  ["/permission", 203],
  ["/role", 204],
  ["/product/category", 301],
  ["/product", 302],
  ["/attendance",501],
	["/leave",502],
	["/business",503]
]);

let iterator = URL_MAP_PAGE_PERMISSION.entries();
let hasError;

const DYNAMICE_URL_MAP_PAGE_PERMISSION = new Map();

batch(async () => {
  let key, value, sql, current;
  while(!(current = iterator.next()).done) {
    key = current.value[0];
    value = current.value[1];
    sql = `select status from permission where id=${value}`;
    try {
      let result = await query(sql);
      if (result && result[0]) {
        // 对应页面的功能正在维护中
        DYNAMICE_URL_MAP_PAGE_PERMISSION.set(
          key,
          // 使用负的权限码表明对应功能模块正在维护中
          result[0].status === 0 ? -value : value
        );
      }
    } catch(e) {
      hasError = hasError || e.message;
      console.log(e);
    }
  }
});

// 路由前缀 映射到 按钮权限码
const URL_MAP_BUTTON_PERMISSION = new Map([
  // 这两个页面没有按钮权限
  ["/overview", {}],
  ["/dashboard", {}],
  ["/attendance",{
		create:50101,
		delete:50102,
		update:50103,
    query:50104,
		queryAll:50105
  }],
	["/leave",{
		create:50101,
		delete:50102,
		update:50103,
	  query:50104,
		queryAll:50105
	}],
	["/business",{
		create:50101,
		delete:50102,
		update:50103,
	  query:50104,
		queryAll:50105
	}],
  [
    "/user",
    {
      create: 20101,
      delete: 20102,
      update: 20103,
      query: 20104
    }
  ],

  [
    "/department",
    {
      create: 20201,
      delete: 20202,
      update: 20203,
      query: 20204
    }
  ],

  [
    "/permission",
    {
      create: 20301,
      delete: 20302,
      update: 20303,
      query: 20304
    }
  ],

  [
    "/role",
    {
      create: 20401,
      delete: 20402,
      update: 20403,
      query: 20404
    }
  ],
  [
    "/product/category",
    {
      create: 30101,
      delete: 30102,
      update: 30103,
      query: 30104
    }
  ],
  [
    "/product",
    {
      create: 30201,
      delete: 30202,
      update: 30203,
      query: 30204
    }
  ]
]);

const DYNAMICE_URL_MAP_BUTTON_PERMISSION = new Map();
let iterator1 = URL_MAP_BUTTON_PERMISSION.entries();

batch(async () => {
  let key, value, sql, current;
  while(!(current = iterator1.next()).done) {
    key = current.value[0];
    value = current.value[1];
    // create update query delete
    let buttonKeys = Object.keys(value);
    // 新的按钮权限对象，来覆盖旧的
    let buttonPermissionObj = {};
    if (buttonKeys.length > 0) {
      // 更新每个按钮权限的状态码
      buttonKeys.forEach(async (buttonKey) => {
        let code = value[buttonKey];
        sql = `select status from permission where id=${code}`;
        try {
          let result = await query(sql);
          if (result && result[0]) {
            buttonPermissionObj[buttonKey] = result[0].status === 0 ? -code : code;
          }
        } catch(e) {
          hasError = hasError || e.message;
          console.log(e);
        }
      });
    }
    DYNAMICE_URL_MAP_BUTTON_PERMISSION.set(
      key,
      buttonPermissionObj
    );
  }
});

const _exports = {
  getPagePermission() {
    return DYNAMICE_URL_MAP_PAGE_PERMISSION;
  },
  getButtonPermission() {
    return DYNAMICE_URL_MAP_BUTTON_PERMISSION
  },
  getSystemPermission() {
    return [1, 2, 3, 4,5]
  },
  hasError() {
    return !!hasError;
  }
}

module.exports =_exports;
