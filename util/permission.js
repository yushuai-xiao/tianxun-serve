const mysql = require("./mysql");
const WebSitePermissionGetter = require("../config/permission");
const tool = require("./tool");

const {batch} = tool;
const {query, queryPermissionsWithSuperId} = mysql;

/** 获取按钮权限， 需要指定1个父级权限Id */
const getButtonPermissions = async (superId) => {
  let permissions = await queryPermissionsWithSuperId(superId) || [];
  let permissionObj = {}
  if (!permissions) {
    return null;
  }
  permissions.forEach((p) => permissionObj[p.button] = p.id);
  return permissionObj;
}


const getAllPermissions = () => {
  const result = [];
  if (WebSitePermissionGetter.hasError()) {
    return [];
  }
  const pps = WebSitePermissionGetter.getPagePermission();
  const bps = WebSitePermissionGetter.getButtonPermission();
  for (let key of pps.keys()) {
    result.push(pps.get(key));
  }
  for (let key of bps.keys()) {
    for (let okey of Object.keys(bps.get(key))) {
      result.push(bps.get(key)[okey]);
    }
  }
  result.push(...WebSitePermissionGetter.getSystemPermission());
  return result.map((item) => Math.abs(item));
};

/** 比较当前权限列表是否出现不合法的权限 current： 当前权限列表*/
const hasInvalidPermission = (current) => {
  let right = getAllPermissions();
	console.log(right,'allRight');
  console.log(current, right);
  if (Array.isArray(current)) {
    if (current.length > right.length) {
      return false;
    }
    return current.some((item) => !right.includes(item))
  }
  return false;
}
module.exports = {
  hasInvalidPermission
};

setTimeout(() => {
  // test:
  // console.log(hasInvalidPermission([101, 102]))
}, 1000);
