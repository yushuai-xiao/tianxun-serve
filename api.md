


# 接口说明

## Base Url

​	 http://zbd329.top:81/tianxun

## Request

请求示例中的字段的初始值的类型就是字段的类型
请求的相关日期格式全部统一：2002-03-29 00:00:00

## Response
响应数据固定包含***code*** 和 ***message***字段，code说明请求的状态，message是该状态的说明
 +  code为0，代表请求接口成功
 +  code为1，代表token已过期，需要重新登录
 +  code为2，代表无权限执行对应操作
 +  code为3，代表请求不合法，使用***message***标记不合法原因
 +  code为4，代表请求合法，但是对应的功能正在维护中~
 +  code为5，服务器内部错误
 请求错误时，从response.data对象获取错误类型和提示，而不是response.status和statusText

响应示例中的字段的初始值的类型就是响应字段的类型
响应的相关日期格式全部统一：2002-03-29 00:00:00

## API

下面每个接口细节中的query或body对象的属性分为**可选**和**必填**，示例：

```javascript
// GET 使用
const query = {
    // 都是必填
    account: "13414",
    password: "zbdfr",
}
// POST DELETE PATCH 使用
const body = {
    id: "zbd1",
    // 选填
    newName?: "新的迷你歌词"
}
```
API示例中的response指的都是response.data

# 接口细节

## 账号模块

### 登录

```javascript
const url = "/account";
const method = "POST"
const body = {
    account: 'zbsg5',
    password: '12345'
}
const response1 = {
    code: 0,
    message: "登录成功~",
    data: {
        userId: "zbd",
        token: 'gag82tnEEITWEA58WQHVGAH',
    }
}
const response2 = {
    code: 3,
    message: "账号或密码错误~",
}
```


## 用户模块

### 获取用户列表

```javascript
const url = "/user/list";
const method = "GET";
const query = {
    uesrName?: "用户名称",
    realName?: "用户真实姓名",
   	cellphone?: "18355895320",
    status?: 1, // 0 | 1
    startTime?: "2002-03-29 00:00:00", 
    endTime?: "2002-03-29 00:00:00",
    current?: 1,
    pageSize?: 10
}
const response = {
    code: 0,
    message: "获取用户列表成功~",
    // 数据总数
    total: 12,
    // 总页数
    pages: 4,
    // 当前页
    current: 1,
    // 每页条数
    pageSize: 10,
    data: [
        {
            id: "zbd",
            // 角色姓名（每个用户都有1个角色）
            roleName: '超级管理员',
            userName: "郑宝迪阿萨",
            realName: "郑宝迪",
            cellphone: "18355895320",
            // 角色是否被禁用
           	status: 1,
            createdTime: '2002-03-29 00:00:00',
            lastModifiedTime: '2002-03-31: 00:00:00',
        }
    ]
}
```

### 获取用户
```javascript 
const url = "/user/:id";
const method = "GET";
const response = {
    code: 0,
    message: "获取用户信息成功~",
    data: {
        id: "root",
        roleName: "超级管理员",
        introduction: "至高无上的神啊!",
        userName: "超级管理员",
        realName: "超级管理元",
        cellphone: "17856754563",
        status: 1,
        createdTime: "2021-12-15 15:33:44",
        lastModifiedTime: "2021-12-16 22:26:42"
    }
}
```

### 创建用户
```javascript
const url =  "/user";
const method = "POST";
const body = {
    userId: "zbd",
    password: "initial_password"
    userName: "新的个性化名称",
    realName?: "郑宝迪",
    cellphone?: "18355895320",
    departmentId?: 13424,
    roleId?: 4111,
}
const response = {
    code: 0,
    message: "创建用户成功~",
}
```
### 更新用户

```javascript
const url =  "/user/:id";
const method = "PATCH";
const body = {
    userId?: "zbd",
    userName?: "新的个性化名称",
    realName?: "郑宝迪",
    cellphone?: "18355895320",
    departmentId?: 13424,
    roleId?: 4111,
    password?: "new_password"
}
const response = {
    code: 0,
    message: "更新用户成功~" | "不存在该用户~",
}
```
### 删除用户

```javascript
const url = "/user/:id";
const method = "DELETE";
const response = {
    code: 0,
    message: "删除用户成功~",
}
```


## 部门模块

### 获取部门列表数据

```javascript
const url = "/department/list";
const method = "GET";
const query = {
    depName?: "部门名称",
    leaderName?: "部长名称",
    startTime?: '2002-03-29 00:00:00', 
    endTime?: '2002-03-29 00:00:00',
    current?: 1,
    pageSize?: 10
}
const response = {
    code: 0,
    message: '获取部门列表成功~',
    total: 12,
    pages: 2,
    current: 1,
    pageSize: 10,
    data: [
        {
            id: 123,
            superId: null,
            depName: "光明帝国",
            leaderId: "zbd",
            leaderName: "谁的包庇",
            createdTime: "2021-12-15 14:40:56",
            lastModifiedTime: "2021-12-15 14:40:59"
        }
    ]
}
```

### 获取部门树形数据

```javascript
const url = "/department/tree";
const method = "GET";
const response = {
    code: 0,
    message: '获取部门数据成功~',
    data: [
        {
       		id: 12425,
            superId: null
            depName: '部门名称',
            leaderId: '114551',
            leaderName: '郑宝迪',
            createdTime: '2002-03-29 00:00:00',
            lastModifiedTime: '2002-03-31: 00:00:00',
            children: [
                {       		
                    id: 5151,
                    superId: 12425
                    depName: '子部门',
                    leaderId: '1145512',
                    leaderName: '啊啊',
                    createdTime: '2002-03-29 00:00:00',
                    lastModifiedTime: '2002-03-31: 00:00:00',
                    children: []
                }
            ]
        }
    ]
}
```

### 创建部门

```javascript
const url =  "/department";
const method = "POST";
const body = {
    leaderId: "zbd",
    name: "光明教廷",
    superId?: 1234,
}
const response = {
    code: 0,
    message: "创建部门成功~"
}
```

### 更新部门

```javascript
const url =  "/department/:id";
const method = "PATCH";
const body = {
    leaderId?: "zbd",
    name?: "光明教廷",
    // 如果要取消父级部门，显示传值-1
    superId?: 123,
}
const response = {
    code: 0,
    message: "更新部门成功~"
}
```

### 删除部门

```javascript
const url = "/department/:id";
const method = "DELETE";
const response = {
    code: 0,
    message: "删除部门成功~"
}
```

### 给部门添加多个用户

```javascript
const url = "/department/relationship";
const method = "POST",
const body = {
    userIds: ['zbd', 'xs'],
    departmentId: 115151
}
const response = {
    code: 0,
    message: '用户与部门绑定成功~'
};
```


## 权限模块

### 获取角色当前的权限
  +  权限分为按钮权限和页面权限，一个权限对象url和button属性不会同时有值
  +  url不为空就是页面权限，button不为空就是按钮权限

```javascript
const url = "/permission/view";
const method = "GET";
const response = {
    code: 0,
    message: '获取菜单成功~',
    data: [
        {
            id: 1,
            name: "系统管理",
            url: "/system",
            superId: null,
            // 权限对应的功能是否维护中
            status: 1,
            button: null,
            createdTime: "2002-03-29 00:00:00",
            lastModifiedTime: "2002-03-29 00:00:00",
            children: [
                id: 101,
                name: "角色管理",
                url: "/system/role",
                superId: 1,
                status: 1,
                button: null,
                createdTime: "2002-03-29 00:00:00",
                lastModifiedTime: "2002-03-29 00:00:00",
                children: [
                    {
                        id: 10101,
                        name: "创建角色",
                        url: null,
                        superId: 101,
                        status: 1,
                        button: "create",
                        children: [],
                        createdTime: "2002-03-29 00:00:00",
                        lastModifiedTime: "2002-03-29 00:00:00",
                    }
                ],
            ]
        }
    ]
};
```

### 获取全部权限

```javascript
const url = "/permission/tree";
const method = "GET";
const response = {
    code: 0,
    message: '获取菜单成功~',
    // 与获取当前角色权限接口返回的数据结构一致
    data: []
};
```

## 角色模块

### 获取角色列表

```javascript
const url = "/role/list";
const method = "GET";
const query = {
    name?: "超级管理员",
    introduction?: "我是角色的介绍",
    current?: 1,
    pageSize?: 10,
    startTime?: '2002-03-29 00:00:00',
    endTime?: '2002-03-29 00:00:00'
}
const response = {
    code: 0,
    message: "获取角色列表成功~",
    data: [
        {
            id: 1,
            name: '超级管理员',
            introduction: '无所不能',
            permissions: "1,2,3,4,5",
            createdTime: '2002-03-29 00:00:00',
            lastModifiedTime: '2002-03-31: 00:00:00',
        }
    ]
};
```

### 创建角色

```javascript
const url = "/role";
const method = "POST";
const body = {
    name: "超级管理员",
    permissions: [1, 2, 3, 4],
    introduction?: "我是角色的介绍"
}
const response = {
    code: 0,
    message: "创建角色成功~",
}
```


### 修改角色

```javascript
const url = "/role/:id";
const method = "PATCH";
const body = {
    name?: "超级管理员",
    introduction?: "我是角色的介绍",
    // 有哪些菜单的权限
    permissions?: [1, 2, 3, 4]
}
const response = {
    code: 0,
    message: "修改角色成功~"
}
```

### 删除角色

```javascript
const url = "/role/:id";
const method = "DELETE";
const response = {
    code: 0,
    message: '删除角色成功~'
}
```

## 商品分类模块

### 获取商品分类列表

```javascript
const url = "/product/category/list";
const method = "GET";
const query = {
    name?: "女装",
    startTime?: '2002-03-29 00:00:00', 
    endTime?: '2002-03-29 00:00:00',
    current?: 1,
    pageSize?: 10,
};
const response = {
    code: 0,
    message: "获取商品分类列表成功~",
    data: [
        {
            id: 1,
            name: '女装大衣',
            createdTime: '2002-03-29 00:00:00',
            lastModifiedTime: '2002-03-31: 00:00:00',
        }
    ]
};
```

### 创建商品分类

```javascript
const url = "/product/category";
const method = "POST";
const body = {
    name: "女装",
};
const response = {
    code: 0,
    message: '创建商品分类成功~',
};
```

### 修改商品分类

```javascript
const url = "/product/category/:id";
const method = "PATCH";
const body = {
    name?: "女装",
};
const response = {
    code: 0,
    message: '修改商品分类成功~'
};
```

### 删除商品分类

```javascript
const url = "/product/category/:id";
const method = "DELETE";
const response = {
    code: 0,
    message: '删除商品分类成功~'
};
```


## 商品模块

### 获取商品列表

```javascript
const url = "/product/list";
const method = "GET";
const query = {
    name?: "漂亮的大衣",
    categoryName?: "女装",
    status?: 1 
    current?: 1,
    pageSize?: 10,
    lowestPrice?: 0,
    highestPrice?: 100,
};
const response = {
    code: 0,
    message: "获取商品列表成功~",
    data: [
        {
            id: 1,
            name: '女装大衣',
            url: '',
            categoryName: '女装',
            originPrice: 200.25,
            currentPrice: 159.32,
            status: 1,
            createdTime: '2002-03-29 00:00:00',
            lastModifiedTime: '2002-03-31: 00:00:00',
        }
    ]
};
```

### 增加商品

```javascript
const url = "/product";
const method = "POST";
const body = {
    name: "漂亮的大衣",
    category?: 123,
    originPrice: 123.55
    currentPrice?: 123.55,
    url?: '//',
    // 默认为0
    status?:0,
    introduction?:"我是商品的介绍"
};
const response = {
    code: 0,
    message: "增加商品成功~"
};
```

### 修改商品

```javascript
const url = "/product/:id";
const method = "PATCH";
const body = {
    name?: "漂亮的大衣",
    category?: 123,
    originPrice?: 123.55
    currentPrice?: 123.55,
    status?:0,
    introduction?:"我是商品的介绍"
};
const response = {
    code: 0,
    message: "修改商品成功~"
};
```

### 删除商品

```javascript
const url = "/product/:id";
const method = "DELETE";
const response = {
    code: 0,
    message: "删除商品成功~"
};
```