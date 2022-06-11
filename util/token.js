const jwt = require('jsonwebtoken');

const secret = 'tianxun-serve';

// 生成jwtToken
const genarteToken = (identity) => {
  return jwt.sign({
    // 半小时后过期
    exp: Math.floor(Date.now() / 1000) + (600 * 30),
    data: {
      permissions: Array.isArray(identity) ? identity : [],
    }
  }, secret);
}

// 验证token
const verifyToken = (token) => {
  try {
    const result = jwt.verify(token, secret);
    console.log(result);
    const { exp = 0 } = result, current = Math.floor(Date.now() / 1000);
    if (current <= exp) {
      return result.data;
    }
  } catch (e) {
    throw new Error(e.message);
  }
}

module.exports = {
  genarteToken,
  verifyToken
}