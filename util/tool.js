// 工具，用来执行函数
const batch = (fn) => {
  if (fn) {
    return fn();
  }
}

// 判断是否是undefined 或者 null
const isUndef = (a) => {
  return typeof a === 'undefined' || a === null;
}

module.exports = {
  batch,
  isUndef
}