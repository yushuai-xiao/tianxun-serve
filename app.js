const express = require('express');
const cors = require('cors');
const JwtUtil = require('./util/token');
const tool = require('./util/tool');
const PermissionTool = require('./util/permission');
const WebSitePermissionGetter = require('./config/permission');

// 接口路由
const accountRouter = require('./router/account');
const userRouter = require('./router/user');
const departmentRouter = require('./router/department');
const permissionRouter = require('./router/permission');
const roleRouter = require('./router/role');
const productRouter = require('./router/product');
const productCategoryRouter = require('./router/product-category');
const workCheckRouter = require('./router/workChcek')
const workHolidayRouter = require('./router/workHoliday')
const workLeaveRouter = require('./router/workLeave')
const workBusinessRouter = require('./router/workBusiness.js')
const { batch } = tool;
// 天巡后台管理服务 网站标识
const WEBSITE_PREFIX = '/tianxun';

const app = express();

// 转为json,格式转换
app.use(express.json());
//  content-type：application /x-www-form-urlencoded
app.use(express.urlencoded());
// cors解决跨域
app.use(cors());
// 静态
app.use(express.static("./public"))

//
const isLoginRequest = (url) => {
  if (!url) return false;
  return url.includes(`${WEBSITE_PREFIX}/account`)
}

// 验证token
app.use((req, res, next) => {
  if (isLoginRequest(req.url)) {
    next();
    return;
  }
  try {
    let token = req.headers.authorization;
    if (!token) {
      throw new Error();
    }
    token = token.replace("Bearer ", '');
    req.body.authorization = JwtUtil.verifyToken(token);
    next();
  } catch (e) {
    console.log('验证token时出错', e);
    res.status(401).send({
      code: 401,
      message: '登录已过期，请重新登录!'
    });
  }
});

// const STATIC_URL = '/';

const methodMapButton = new Map([
  ["GET", "query"],
  ["PATCH", "update"],
  ["POST", "create"],
  ["DELETE", "delete"]
]);

const filterURL = ["permission/view","department/list","user","role/list"];

// 是否有对应路由权限的验证
app.use((req, res, next) => {
  if (isLoginRequest(req.url) || filterURL.some((furl) => req.url.includes(furl))) {
    next();
    return;
  }
  let url = req.url.replace(WEBSITE_PREFIX, '');
  // console.log("要验证的url:", url);

  let method = req.method.toUpperCase();
  let needValidateMethods = ['GET', 'POST', 'PATCH', 'DELETE'];
  // console.log("当前请求方法:", method);
  if (!needValidateMethods.includes(method)) {
    // console.log("其它请求");
    next();
    return;
  }

  if (WebSitePermissionGetter.hasError()) {
    res.status(500).json({
      code: 500,
      message: '后台出了点故障呢~'
    });
    return;
  }

  let _404 = () => {
    res.status(404).end();
  }

  // 没有权限，而不是没有token
  let _noPermission = (isPage) => {
    res.status(403).json({
      code: 403,
      message: isPage ? "无页面权限~" : "无按钮权限~"
    });
  }

  let userPermissions = req.body.authorization.permissions.filter((item) => !!item).map((item) => parseInt(item));
  // console.log("用户当前的权限:", userPermissions);

  let allPagePermissions = WebSitePermissionGetter.getPagePermission();
  // console.log("全部的页面权限:", allPagePermissions)
  ;
  // 找到当前url匹配到的权限
  let permissionMatchedUrl = batch(() => {
    for (let key of allPagePermissions.keys()) {
      if (url.startsWith(key)) {
        return key;
      }
    }
  });
  // console.log("根据URL匹配到的权限key:", permissionMatchedUrl)
  // 将当前url匹配到的权限和全部权限进行比对
  if (!permissionMatchedUrl) {
    // console.log("没有url对应的权限，这是非法的");
    _404();
    return;
  }

  let currentPagePermission = allPagePermissions.get(permissionMatchedUrl);
  // console.log("当前页面权限:", currentPagePermission);

  if (!userPermissions.includes(currentPagePermission)) {
    // 权限标识在数据库中都是正的，WebSitePermissionGetter对权限标识做了特殊处理
    // 权限是可以启用和禁用的，如果它是禁用的，WebSitePermissionGetter存储它的负值来体现这一特征
    if (userPermissions.includes(-currentPagePermission)) {
      res.status(200).json({
        code: 202,
        message: '功能正在维护中~'
      });
    } else {
      _noPermission(true);
    }
    return;
  }

  // 通过页面权限验证, 下面需要验证按钮权限
  let allButtonPermissions = WebSitePermissionGetter.getButtonPermission();
  // console.log("全部按钮权限:", allButtonPermissions)
  let currentButtonPermission = allButtonPermissions.get(permissionMatchedUrl)[methodMapButton.get(method)];
  // console.log("当前按钮权限:", currentButtonPermission);

  if (!userPermissions.includes(currentButtonPermission)) {
    // 同页面权限一样
    if (userPermissions.includes(-currentButtonPermission)) {
      res.status(200).json({
        code: 202,
        message: batch(() => {
          switch (method) {
            case "GET":
              return "查询功能正在维护中~";
            case "POST":
              return "创建功能正在维护中~";
            case "PATCH":
              return "更新功能正在维护中~";
            case "DELETE":
              return "删除功能正在维护中~";
            default:
              return "功能正在维护中~";
          }
        })
      });
    } else {
      _noPermission(false);
    }
    return;
  }
  next();
});
// 路由前缀，后面是方法
app.use(WEBSITE_PREFIX, accountRouter);
app.use(WEBSITE_PREFIX, userRouter);
app.use(WEBSITE_PREFIX, departmentRouter);
app.use(WEBSITE_PREFIX, permissionRouter);
app.use(WEBSITE_PREFIX, roleRouter);
app.use(WEBSITE_PREFIX, productCategoryRouter);
app.use(WEBSITE_PREFIX, productRouter);
app.use(WEBSITE_PREFIX, workCheckRouter);
app.use(WEBSITE_PREFIX,workHolidayRouter)
app.use(WEBSITE_PREFIX,workLeaveRouter)
app.use(WEBSITE_PREFIX,workBusinessRouter)

app.listen(8081, '0.0.0.0', () => {
  console.log("tianxun服务器已启动");
});
