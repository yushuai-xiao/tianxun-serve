/*
 Navicat Premium Data Transfer

 Source Server         : conn
 Source Server Type    : MySQL
 Source Server Version : 50722
 Source Host           : localhost:3306
 Source Schema         : bs_admin

 Target Server Type    : MySQL
 Target Server Version : 50722
 File Encoding         : 65001

 Date: 20/06/2022 08:34:55
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for buy_record
-- ----------------------------
DROP TABLE IF EXISTS `buy_record`;
CREATE TABLE `buy_record`  (
  `id` int(10) UNSIGNED NOT NULL,
  `user_id` varchar(10) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `product_id` int(10) UNSIGNED NOT NULL,
  `price` decimal(10, 2) UNSIGNED NOT NULL,
  `time` datetime(0) NULL DEFAULT NULL,
  `location` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `ip` char(15) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `record_user_ref`(`user_id`) USING BTREE,
  INDEX `record_prod_ref`(`product_id`) USING BTREE,
  CONSTRAINT `record_prod_ref` FOREIGN KEY (`product_id`) REFERENCES `product` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
  CONSTRAINT `record_user_ref` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for config
-- ----------------------------
DROP TABLE IF EXISTS `config`;
CREATE TABLE `config`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `start` time(0) NOT NULL,
  `end` time(0) NULL DEFAULT NULL,
  `lat` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `lng` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `location` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `create_time` datetime(0) NULL DEFAULT NULL,
  `update_time` datetime(0) NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `config_id_uindex`(`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 102 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of config
-- ----------------------------
INSERT INTO `config` VALUES (101, '08:19:33', '12:19:33', '31.752735', '117.254062', '合肥学院南艳湖校区', '2022-04-28 15:15:04', '2022-04-28 15:15:04');

-- ----------------------------
-- Table structure for department
-- ----------------------------
DROP TABLE IF EXISTS `department`;
CREATE TABLE `department`  (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `leader` varchar(10) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `super_id` int(10) UNSIGNED NULL DEFAULT NULL COMMENT '父级部门',
  `introduction` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `create_time` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `last_modify_time` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `dep_super_dep_ref`(`super_id`) USING BTREE,
  INDEX `dep_leader_ref`(`leader`) USING BTREE,
  CONSTRAINT `dep_leader_ref` FOREIGN KEY (`leader`) REFERENCES `user` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `dep_super_dep_ref` FOREIGN KEY (`super_id`) REFERENCES `department` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB AUTO_INCREMENT = 1229 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of department
-- ----------------------------
INSERT INTO `department` VALUES (1001, '人力资源部', 'zbd', NULL, NULL, '2021-12-19 16:54:34', '2021-12-19 16:54:34');
INSERT INTO `department` VALUES (1002, '总裁办', 'root', NULL, NULL, '2021-12-19 17:04:49', '2021-12-19 17:04:49');
INSERT INTO `department` VALUES (1003, '研发部', 'xs', NULL, NULL, '2021-12-19 17:08:13', '2021-12-19 17:08:13');
INSERT INTO `department` VALUES (1004, '财务部', NULL, NULL, NULL, '2021-12-19 17:08:52', '2021-12-19 17:08:52');
INSERT INTO `department` VALUES (1228, '测试三个部', NULL, NULL, NULL, '2021-12-19 20:02:49', '2021-12-19 20:02:49');

-- ----------------------------
-- Table structure for error_tool
-- ----------------------------
DROP TABLE IF EXISTS `error_tool`;
CREATE TABLE `error_tool`  (
  `id` int(1) NOT NULL
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of error_tool
-- ----------------------------
INSERT INTO `error_tool` VALUES (1);
INSERT INTO `error_tool` VALUES (2);
INSERT INTO `error_tool` VALUES (1);
INSERT INTO `error_tool` VALUES (2);
INSERT INTO `error_tool` VALUES (3);
INSERT INTO `error_tool` VALUES (4);
INSERT INTO `error_tool` VALUES (101);
INSERT INTO `error_tool` VALUES (102);
INSERT INTO `error_tool` VALUES (201);
INSERT INTO `error_tool` VALUES (202);
INSERT INTO `error_tool` VALUES (203);
INSERT INTO `error_tool` VALUES (205);
INSERT INTO `error_tool` VALUES (2);

-- ----------------------------
-- Table structure for holiday
-- ----------------------------
DROP TABLE IF EXISTS `holiday`;
CREATE TABLE `holiday`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `time` datetime(0) NULL,
  `remark` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `create_time` datetime(0) NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime(0) NULL DEFAULT CURRENT_TIMESTAMP,
  `start_time` datetime(0) NOT NULL COMMENT '假期开始时间',
  `end_time` datetime(0) NOT NULL COMMENT '假期结束时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `holiday_id_uindex`(`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 5 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of holiday
-- ----------------------------
INSERT INTO `holiday` VALUES (4, '2021-05-30 16:00:00', '六一la', '2021-03-01 13:15:55', '2022-05-26 22:02:27', '2022-06-01 00:00:00', '2022-06-07 00:00:00');

-- ----------------------------
-- Table structure for permission
-- ----------------------------
DROP TABLE IF EXISTS `permission`;
CREATE TABLE `permission`  (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `url` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `icon` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT 'icon',
  `button` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `name` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '菜单名称',
  `superId` int(10) UNSIGNED NULL DEFAULT NULL COMMENT '父级菜单ID',
  `create_time` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `last_modify_time` datetime(0) NULL DEFAULT NULL,
  `status` tinyint(4) NOT NULL DEFAULT 1,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `super_menu_ref`(`superId`) USING BTREE,
  CONSTRAINT `super_menu_ref` FOREIGN KEY (`superId`) REFERENCES `permission` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE = InnoDB AUTO_INCREMENT = 50106 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of permission
-- ----------------------------
INSERT INTO `permission` VALUES (1, '/main/analysis', 'House', NULL, '系统总览', NULL, '2021-12-15 21:14:06', '2021-12-15 21:14:08', 1);
INSERT INTO `permission` VALUES (2, '/main/system', 'histogram', NULL, '系统管理', NULL, '2021-12-15 21:16:27', '2021-12-15 21:16:27', 1);
INSERT INTO `permission` VALUES (3, '/main/product', 'shop', NULL, '调休中心', NULL, '2021-12-15 21:17:42', '2021-12-15 21:17:42', 1);
INSERT INTO `permission` VALUES (4, '/main/story', 'avatar', NULL, '测试页面', NULL, '2021-12-15 21:18:07', '2021-12-15 21:18:07', 1);
INSERT INTO `permission` VALUES (5, '/main/attendance', 'histogram', NULL, '考勤管理', NULL, '2022-05-21 23:51:55', NULL, 1);
INSERT INTO `permission` VALUES (101, '/main/analysis/overview', '', NULL, '核心技术', 1, '2021-12-15 21:19:14', '2021-12-15 21:19:14', 1);
INSERT INTO `permission` VALUES (102, '/main/analysis/dashboard', 'Histogram', NULL, '考勤统计', 1, '2021-12-15 21:19:55', '2021-12-15 21:19:55', 1);
INSERT INTO `permission` VALUES (201, '/main/system/user', 'Avatar', NULL, '用户管理', 2, '2021-12-15 21:21:07', '2021-12-15 21:21:07', 1);
INSERT INTO `permission` VALUES (202, '/main/system/department', 'Management', NULL, '部门管理', 2, '2021-12-15 21:22:00', '2021-12-15 21:22:00', 1);
INSERT INTO `permission` VALUES (203, '/main/system/menu', 'Menu', NULL, '菜单管理', 2, '2021-12-15 21:23:05', '2021-12-15 21:23:05', 1);
INSERT INTO `permission` VALUES (204, '/main/system/role', 'UserFilled', NULL, '角色管理', 2, '2021-12-15 21:23:40', '2021-12-15 21:23:40', 1);
INSERT INTO `permission` VALUES (301, '/main/product/category', '', NULL, '加班管理', 3, '2021-12-15 21:24:21', '2021-12-15 21:24:21', 1);
INSERT INTO `permission` VALUES (302, '/main/product/goods', '', NULL, '调休管理', 3, '2021-12-15 21:25:15', '2021-12-15 21:25:15', 1);
INSERT INTO `permission` VALUES (401, '/main/story/chat', '', NULL, '测试页面', 4, '2021-12-15 21:25:54', '2021-12-15 21:25:54', 1);
INSERT INTO `permission` VALUES (501, '/main/attendance/index', 'ElemeFilled', NULL, '考勤管理', 5, '2022-05-21 23:58:03', NULL, 1);
INSERT INTO `permission` VALUES (502, '/main/attendance/leave', 'Comment', NULL, '请假管理', 5, '2022-05-21 23:59:44', NULL, 1);
INSERT INTO `permission` VALUES (503, '/main/attendance/business', 'List', NULL, '出差管理', 5, '2022-05-22 00:00:30', NULL, 1);
INSERT INTO `permission` VALUES (20101, NULL, '', 'create', '创建用户', 201, '2021-12-15 21:28:00', '2021-12-15 21:28:00', 1);
INSERT INTO `permission` VALUES (20102, NULL, '', 'delete', '删除用户', 201, '2021-12-15 21:30:21', '2021-12-15 21:30:21', 1);
INSERT INTO `permission` VALUES (20103, NULL, '', 'update', '更新用户', 201, '2021-12-15 21:30:42', '2021-12-15 21:30:42', 1);
INSERT INTO `permission` VALUES (20104, NULL, '', 'query', '查询用户', 201, '2021-12-15 21:31:10', '2021-12-15 21:31:10', 1);
INSERT INTO `permission` VALUES (20201, NULL, '', 'create', '创建部门', 202, '2021-12-15 21:31:38', '2021-12-15 21:31:38', 1);
INSERT INTO `permission` VALUES (20202, NULL, '', 'delete', '删除部门', 202, '2021-12-15 21:31:54', '2021-12-15 21:31:54', 1);
INSERT INTO `permission` VALUES (20203, NULL, '', 'update', '更新部门', 202, '2021-12-15 21:32:30', '2021-12-15 21:32:30', 1);
INSERT INTO `permission` VALUES (20204, NULL, '', 'query', '查询部门', 202, '2021-12-15 21:32:46', '2021-12-15 21:32:46', 1);
INSERT INTO `permission` VALUES (20303, NULL, '', 'update', '更新菜单', 203, '2021-12-15 21:34:18', '2021-12-15 21:34:18', 1);
INSERT INTO `permission` VALUES (20304, NULL, '', 'query', '查询菜单', 203, '2021-12-15 21:34:44', '2021-12-15 21:34:44', 1);
INSERT INTO `permission` VALUES (20401, NULL, '', 'create', '创建角色', 204, '2021-12-15 21:35:04', '2021-12-15 21:35:04', 1);
INSERT INTO `permission` VALUES (20402, NULL, '', 'delete', '删除角色', 204, '2021-12-15 21:35:19', '2021-12-15 21:35:19', 1);
INSERT INTO `permission` VALUES (20403, NULL, '', 'update', '更新角色', 204, '2021-12-15 21:35:31', '2021-12-15 21:35:31', 1);
INSERT INTO `permission` VALUES (20404, NULL, '', 'query', '查询角色', 204, '2021-12-15 21:35:50', '2021-12-15 21:35:50', 1);
INSERT INTO `permission` VALUES (30101, NULL, '', 'create', '创建商品类别', 301, '2021-12-15 21:46:09', '2021-12-15 21:46:09', 1);
INSERT INTO `permission` VALUES (30102, NULL, '', 'delete', '删除商品类别', 301, '2021-12-15 21:46:45', '2021-12-15 21:46:45', 1);
INSERT INTO `permission` VALUES (30103, NULL, '', 'update', '更新商品类型', 301, '2021-12-15 21:46:54', '2021-12-15 21:46:54', 1);
INSERT INTO `permission` VALUES (30104, NULL, '', 'query', '查询商品类型', 301, '2021-12-15 21:47:15', '2021-12-15 21:47:15', 1);
INSERT INTO `permission` VALUES (30201, NULL, '', 'create', '创建商品', 302, '2021-12-15 21:47:51', '2021-12-15 21:47:51', 1);
INSERT INTO `permission` VALUES (30202, NULL, '', 'delete', '删除商品', 302, '2021-12-15 21:48:20', '2021-12-15 21:48:20', 1);
INSERT INTO `permission` VALUES (30203, NULL, '', 'update', '更新商品', 302, '2021-12-15 21:48:29', '2021-12-15 21:48:29', 1);
INSERT INTO `permission` VALUES (30204, NULL, '', 'query', '查询商品', 302, '2021-12-15 21:49:06', '2021-12-15 21:49:06', 1);
INSERT INTO `permission` VALUES (50101, NULL, NULL, 'create', '创建', 501, '2022-05-26 00:11:04', NULL, 1);
INSERT INTO `permission` VALUES (50102, NULL, NULL, 'delete', '删除', 501, '2022-05-26 00:11:34', NULL, 1);
INSERT INTO `permission` VALUES (50103, NULL, NULL, 'update', '更新', 501, '2022-05-26 00:11:50', NULL, 1);
INSERT INTO `permission` VALUES (50104, NULL, NULL, 'query', '查询工作记录', 501, '2022-05-23 22:25:13', NULL, 1);
INSERT INTO `permission` VALUES (50105, NULL, NULL, 'queryAll', '查询全部工作记录', 501, '2022-05-28 17:10:32', NULL, 1);

-- ----------------------------
-- Table structure for permission_copy1
-- ----------------------------
DROP TABLE IF EXISTS `permission_copy1`;
CREATE TABLE `permission_copy1`  (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `url` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `icon` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT 'icon',
  `button` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `name` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '菜单名称',
  `superId` int(10) UNSIGNED NULL DEFAULT NULL COMMENT '父级菜单ID',
  `create_time` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `last_modify_time` datetime(0) NULL DEFAULT NULL,
  `status` tinyint(4) NOT NULL DEFAULT 1,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `super_menu_ref`(`superId`) USING BTREE,
  CONSTRAINT `permission_copy1_ibfk_1` FOREIGN KEY (`superId`) REFERENCES `permission` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE = InnoDB AUTO_INCREMENT = 30205 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of permission_copy1
-- ----------------------------
INSERT INTO `permission_copy1` VALUES (1, '/main/analysis', 'House', NULL, '系统总览', NULL, '2021-12-15 21:14:06', '2021-12-15 21:14:08', 1);
INSERT INTO `permission_copy1` VALUES (2, '/main/system', 'histogram', NULL, '系统管理', NULL, '2021-12-15 21:16:27', '2021-12-15 21:16:27', 1);
INSERT INTO `permission_copy1` VALUES (3, '/main/product', 'shop', NULL, '商品中心', NULL, '2021-12-15 21:17:42', '2021-12-15 21:17:42', 1);
INSERT INTO `permission_copy1` VALUES (4, '/main/story', 'avatar', NULL, '测试页面', NULL, '2021-12-15 21:18:07', '2021-12-15 21:18:07', 1);
INSERT INTO `permission_copy1` VALUES (101, '/main/analysis/overview', '', NULL, '核心技术', 1, '2021-12-15 21:19:14', '2021-12-15 21:19:14', 1);
INSERT INTO `permission_copy1` VALUES (102, '/main/analysis/dashboard', '', NULL, '商品统计', 1, '2021-12-15 21:19:55', '2021-12-15 21:19:55', 1);
INSERT INTO `permission_copy1` VALUES (201, '/main/system/user', '', NULL, '用户管理', 2, '2021-12-15 21:21:07', '2021-12-15 21:21:07', 1);
INSERT INTO `permission_copy1` VALUES (202, '/main/system/department', '', NULL, '部门管理', 2, '2021-12-15 21:22:00', '2021-12-15 21:22:00', 1);
INSERT INTO `permission_copy1` VALUES (203, '/main/system/menu', '', NULL, '菜单管理', 2, '2021-12-15 21:23:05', '2021-12-15 21:23:05', 1);
INSERT INTO `permission_copy1` VALUES (204, '/main/system/role', '', NULL, '角色管理', 2, '2021-12-15 21:23:40', '2021-12-15 21:23:40', 1);
INSERT INTO `permission_copy1` VALUES (301, '/main/product/category', '', NULL, '商品类别', 3, '2021-12-15 21:24:21', '2021-12-15 21:24:21', 1);
INSERT INTO `permission_copy1` VALUES (302, '/main/product/goods', '', NULL, '商品信息', 3, '2021-12-15 21:25:15', '2021-12-15 21:25:15', 1);
INSERT INTO `permission_copy1` VALUES (401, '/main/story/chat', '', NULL, '测试页面', 4, '2021-12-15 21:25:54', '2021-12-15 21:25:54', 1);
INSERT INTO `permission_copy1` VALUES (20101, NULL, '', 'create', '创建用户', 201, '2021-12-15 21:28:00', '2021-12-15 21:28:00', 1);
INSERT INTO `permission_copy1` VALUES (20102, NULL, '', 'delete', '删除用户', 201, '2021-12-15 21:30:21', '2021-12-15 21:30:21', 1);
INSERT INTO `permission_copy1` VALUES (20103, NULL, '', 'update', '更新用户', 201, '2021-12-15 21:30:42', '2021-12-15 21:30:42', 1);
INSERT INTO `permission_copy1` VALUES (20104, NULL, '', 'query', '查询用户', 201, '2021-12-15 21:31:10', '2021-12-15 21:31:10', 1);
INSERT INTO `permission_copy1` VALUES (20201, NULL, '', 'create', '创建部门', 202, '2021-12-15 21:31:38', '2021-12-15 21:31:38', 1);
INSERT INTO `permission_copy1` VALUES (20202, NULL, '', 'delete', '删除部门', 202, '2021-12-15 21:31:54', '2021-12-15 21:31:54', 1);
INSERT INTO `permission_copy1` VALUES (20203, NULL, '', 'update', '更新部门', 202, '2021-12-15 21:32:30', '2021-12-15 21:32:30', 1);
INSERT INTO `permission_copy1` VALUES (20204, NULL, '', 'query', '查询部门', 202, '2021-12-15 21:32:46', '2021-12-15 21:32:46', 1);
INSERT INTO `permission_copy1` VALUES (20303, NULL, '', 'update', '更新菜单', 203, '2021-12-15 21:34:18', '2021-12-15 21:34:18', 1);
INSERT INTO `permission_copy1` VALUES (20304, NULL, '', 'query', '查询菜单', 203, '2021-12-15 21:34:44', '2021-12-15 21:34:44', 1);
INSERT INTO `permission_copy1` VALUES (20401, NULL, '', 'create', '创建角色', 204, '2021-12-15 21:35:04', '2021-12-15 21:35:04', 1);
INSERT INTO `permission_copy1` VALUES (20402, NULL, '', 'delete', '删除角色', 204, '2021-12-15 21:35:19', '2021-12-15 21:35:19', 1);
INSERT INTO `permission_copy1` VALUES (20403, NULL, '', 'update', '更新角色', 204, '2021-12-15 21:35:31', '2021-12-15 21:35:31', 1);
INSERT INTO `permission_copy1` VALUES (20404, NULL, '', 'query', '查询角色', 204, '2021-12-15 21:35:50', '2021-12-15 21:35:50', 1);
INSERT INTO `permission_copy1` VALUES (30101, NULL, '', 'create', '创建商品类别', 301, '2021-12-15 21:46:09', '2021-12-15 21:46:09', 1);
INSERT INTO `permission_copy1` VALUES (30102, NULL, '', 'delete', '删除商品类别', 301, '2021-12-15 21:46:45', '2021-12-15 21:46:45', 1);
INSERT INTO `permission_copy1` VALUES (30103, NULL, '', 'update', '更新商品类型', 301, '2021-12-15 21:46:54', '2021-12-15 21:46:54', 1);
INSERT INTO `permission_copy1` VALUES (30104, NULL, '', 'query', '查询商品类型', 301, '2021-12-15 21:47:15', '2021-12-15 21:47:15', 1);
INSERT INTO `permission_copy1` VALUES (30201, NULL, '', 'create', '创建商品', 302, '2021-12-15 21:47:51', '2021-12-15 21:47:51', 1);
INSERT INTO `permission_copy1` VALUES (30202, NULL, '', 'delete', '删除商品', 302, '2021-12-15 21:48:20', '2021-12-15 21:48:20', 1);
INSERT INTO `permission_copy1` VALUES (30203, NULL, '', 'update', '更新商品', 302, '2021-12-15 21:48:29', '2021-12-15 21:48:29', 1);
INSERT INTO `permission_copy1` VALUES (30204, NULL, '', 'query', '查询商品', 302, '2021-12-15 21:49:06', '2021-12-15 21:49:06', 1);

-- ----------------------------
-- Table structure for product
-- ----------------------------
DROP TABLE IF EXISTS `product`;
CREATE TABLE `product`  (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `introduction` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `origin_price` decimal(10, 2) NOT NULL,
  `current_price` decimal(10, 2) NOT NULL,
  `url` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `status` tinyint(4) NOT NULL DEFAULT 0,
  `create_time` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `last_modify_time` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `category` int(10) UNSIGNED NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `prod_categroy_ref`(`category`) USING BTREE,
  CONSTRAINT `prod_categroy_ref` FOREIGN KEY (`category`) REFERENCES `product_category` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE = InnoDB AUTO_INCREMENT = 149 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of product
-- ----------------------------
INSERT INTO `product` VALUES (6, '2018春秋新款韩版灯芯绒小脚哈伦裤女学生宽松萝卜裤显瘦九分裤休闲裤', '2018春秋新款韩版灯芯绒小脚哈伦裤女学生宽松萝卜裤显瘦九分裤休闲裤', 70.00, 49.00, 'http://s11.mogucdn.com/mlcdn/c45406/171210_0a0kc9igaaf74jgcf1j150874daa3_640x960.jpg_560x999.jpg', 1, '2021-12-18 14:27:29', '2021-12-18 14:27:29', 7);
INSERT INTO `product` VALUES (7, '吊带背心女夏2018秋季新款内搭吊带衫短款性感修身针织打底衫上衣显瘦', '吊带背心女夏2018秋季新款内搭吊带衫短款性感修身针织打底衫上衣显瘦', 43.00, 30.00, 'http://s11.mogucdn.com/mlcdn/17f85e/180927_5i77e04lhaalbg3dai0j4588lbahh_640x960.jpg_560x999.jpg', 1, '2021-12-18 14:27:29', '2021-12-18 14:27:29', NULL);
INSERT INTO `product` VALUES (8, '2018秋装女装韩版新款休闲时尚套装女圆领条纹薄款上衣+高腰束脚灯笼裤两件套女潮', '2018秋装女装韩版新款休闲时尚套装女圆领条纹薄款上衣+高腰束脚灯笼裤两件套女潮', 198.00, 198.00, 'http://s11.mogucdn.com/mlcdn/55cf19/180803_44ec95haiehdddjk126fgidfg52le_640x960.jpg_560x999.jpg', 1, '2021-12-18 14:27:29', '2021-12-18 14:27:29', 6);
INSERT INTO `product` VALUES (9, '2018秋季新款时尚套装蝴蝶结波点衬衫圆领麻花毛衣无袖马甲百褶半身裙中长款A字裙套装三件套', '2018秋季新款时尚套装蝴蝶结波点衬衫圆领麻花毛衣无袖马甲百褶半身裙中长款A字裙套装三件套', 86.00, 60.00, 'http://s11.mogucdn.com/mlcdn/c45406/180131_1kgh02j1j4lbb74g0427ljk976612_640x960.jpg_560x999.jpg', 1, '2021-12-18 14:27:29', '2021-12-18 14:27:29', 5);
INSERT INTO `product` VALUES (10, '2018早秋新款港风时尚套装复古Polo领长袖衬衫温柔风无袖小个子吊带连衣裙两件套', '2018早秋新款港风时尚套装复古Polo领长袖衬衫温柔风无袖小个子吊带连衣裙两件套', 70.00, 49.00, 'http://s3.mogucdn.com/mlcdn/c45406/180820_2a2fja7ef28g254ki63cg6b3jkhgl_640x960.jpg_560x999.jpg', 1, '2021-12-18 14:27:29', '2021-12-18 14:27:29', 8);
INSERT INTO `product` VALUES (11, '2018秋冬新款时尚韩范百搭显瘦背带裤套装灯芯绒裤子+毛衣两件套女', '2018秋冬新款时尚韩范百搭显瘦背带裤套装灯芯绒裤子+毛衣两件套女', 99.00, 69.00, 'http://s11.mogucdn.com/mlcdn/55cf19/180831_3lccd4912aec0lb8fga9ji7ah6bkd_640x960.jpg_560x999.jpg', 1, '2021-12-18 14:27:29', '2021-12-18 14:27:29', 7);
INSERT INTO `product` VALUES (12, '秋装2018新款牛仔外套女韩版宽松短款针织背心高腰半身裙中长裙小个子显高时尚套装裙子三件套', '秋装2018新款牛仔外套女韩版宽松短款针织背心高腰半身裙中长裙小个子显高时尚套装裙子三件套', 39.00, 27.00, 'http://s3.mogucdn.com/mlcdn/c45406/180731_5be6jhh7ggj68d4063gkca4egh02i_750x1000.jpg_560x999.jpg', 1, '2021-12-18 14:27:29', '2021-12-18 14:27:29', 5);
INSERT INTO `product` VALUES (13, '2018秋装套装新款韩版百搭显瘦长袖条纹雪纺衬衫女宽松直筒背带裤套装两件套', '2018秋装套装新款韩版百搭显瘦长袖条纹雪纺衬衫女宽松直筒背带裤套装两件套', 84.00, 59.00, 'http://s11.mogucdn.com/mlcdn/c45406/180312_5ebi8i8k389leic0g487h3l611kek_640x960.jpg_560x999.jpg', 1, '2021-12-18 14:27:29', '2021-12-18 14:27:29', 8);
INSERT INTO `product` VALUES (14, '时尚套装韩版气质甜美镂空灯笼袖针织衫百搭显瘦毛衣女2018秋季新款连衣裙套装', '时尚套装韩版气质甜美镂空灯笼袖针织衫百搭显瘦毛衣女2018秋季新款连衣裙套装', 70.00, 70.00, 'http://s11.mogucdn.com/mlcdn/c45406/180822_5bl46cl4g934133a6cbhkk8l37hl0_640x960.jpg_560x999.jpg', 1, '2021-12-18 14:27:29', '2021-12-18 14:27:29', 6);
INSERT INTO `product` VALUES (15, '格姬2018秋季新款港风休闲小西装套装女时尚OL两件套九分裤简约纯色休闲西服外套女6970', '格姬2018秋季新款港风休闲小西装套装女时尚OL两件套九分裤简约纯色休闲西服外套女6970', 256.00, 179.00, 'http://s11.mogucdn.com/mlcdn/c45406/180813_71b8h486f66358dal3hg12f90ba58_640x960.jpg_560x999.jpg', 1, '2021-12-18 14:27:29', '2021-12-18 14:27:29', NULL);
INSERT INTO `product` VALUES (16, '2018秋装新款韩版宽松针织开衫毛衣外套上衣女修身显瘦吊带连衣裙两件套学生裙子时尚套装', '2018秋装新款韩版宽松针织开衫毛衣外套上衣女修身显瘦吊带连衣裙两件套学生裙子时尚套装', 99.00, 69.00, 'http://s3.mogucdn.com/mlcdn/c45406/180901_4lc505f9hgb86106k8cjcljj25294_640x960.jpg_560x999.jpg', 0, '2021-12-18 14:27:29', '2021-12-30 12:16:22', 5);
INSERT INTO `product` VALUES (17, '2018秋装新款韩版宽松针织开衫毛衣外套中长气质v领针织连衣裙打底吊带裙两件套时尚裙子套装', '2018秋装新款韩版宽松针织开衫毛衣外套中长气质v领针织连衣裙打底吊带裙两件套时尚裙子套装', 99.00, 69.00, 'http://s11.mogucdn.com/mlcdn/c45406/180816_8gb546fel3dic1i6d44fj217l49eg_640x960.jpg_560x999.jpg', 1, '2021-12-18 14:27:29', '2021-12-18 14:27:29', 7);
INSERT INTO `product` VALUES (18, '格姬2018秋装新款两件套圆领灯笼袖连衣裙春装新款韩版名媛大裙摆套装裙时尚套装女6254', '格姬2018秋装新款两件套圆领灯笼袖连衣裙春装新款韩版名媛大裙摆套装裙时尚套装女6254', 285.00, 199.00, 'http://s3.mogucdn.com/mlcdn/c45406/180302_4ji3hab7c3kdhfdg4i0lc86a1287h_640x960.jpg_560x999.jpg', 1, '2021-12-18 14:27:29', '2021-12-18 14:27:29', NULL);
INSERT INTO `product` VALUES (19, '2018秋季新款韩版女装喇叭袖V领套头打底针织衫上衣+显瘦a字黑色半身裙皮裙两件套时尚套装', '2018秋季新款韩版女装喇叭袖V领套头打底针织衫上衣+显瘦a字黑色半身裙皮裙两件套时尚套装', 84.00, 59.00, 'http://s3.mogucdn.com/mlcdn/c45406/170928_4hk375c1c1ldgl7bhi08e1hk23ji1_640x960.jpg_560x999.jpg', 1, '2021-12-18 14:27:29', '2021-12-18 14:27:29', 10);
INSERT INTO `product` VALUES (20, '2018秋季新款韩版时尚套装百搭宽松连帽印花卫衣+高腰显瘦九分哈伦裤牛仔裤两件套潮', '2018秋季新款韩版时尚套装百搭宽松连帽印花卫衣+高腰显瘦九分哈伦裤牛仔裤两件套潮', 99.00, 69.00, 'http://s11.mogucdn.com/mlcdn/c45406/180819_036kb000jg39i651jbgf4kg5df084_640x960.jpg_560x999.jpg', 1, '2021-12-18 14:27:29', '2021-12-18 14:27:29', 7);
INSERT INTO `product` VALUES (21, '港风少女短款牛仔外套女2018新款韩版牛仔衣夹克潮+高腰流苏蛋糕裙半身裙女蕾丝短裙两件套装', '港风少女短款牛仔外套女2018新款韩版牛仔衣夹克潮+高腰流苏蛋糕裙半身裙女蕾丝短裙两件套装', 113.00, 79.00, 'http://s3.mogucdn.com/mlcdn/c45406/180723_827dgd0bdj5i4egcleje6j35eebbc_640x960.jpg_560x999.jpg', 1, '2021-12-18 14:27:29', '2021-12-18 14:27:29', 6);
INSERT INTO `product` VALUES (22, '2018秋季新款百搭短款针织衫+宽松显瘦哈伦牛仔裤时尚两件套', '2018秋季新款百搭短款针织衫+宽松显瘦哈伦牛仔裤时尚两件套', 70.00, 49.00, 'http://s3.mogucdn.com/mlcdn/55cf19/180828_4l2e9729iabakghcd44dkbe560h5b_640x960.jpg_560x999.jpg', 1, '2021-12-18 14:27:29', '2021-12-18 14:27:29', 8);
INSERT INTO `product` VALUES (23, '时尚套装两件套网红同款2018秋装女套装新款学生牛仔外套配内搭温柔风小黑裙黑色v领吊带裙潮', '时尚套装两件套网红同款2018秋装女套装新款学生牛仔外套配内搭温柔风小黑裙黑色v领吊带裙潮', 100.00, 70.00, 'http://s3.mogucdn.com/mlcdn/c45406/180819_44ee3hf251agika4lji8958i46e6d_640x960.jpg_560x999.jpg', 1, '2021-12-18 14:27:29', '2021-12-18 14:27:29', 9);
INSERT INTO `product` VALUES (24, '2018秋季新款韩版小清新学生短款港味露脐长袖上衣女+百搭高腰束脚休闲长裤时尚套装两件套潮', '2018秋季新款韩版小清新学生短款港味露脐长袖上衣女+百搭高腰束脚休闲长裤时尚套装两件套潮', 141.00, 99.00, 'http://s3.mogucdn.com/mlcdn/c45406/180828_6g8gg6740942163ddi6hgeacj4983_640x960.jpg_560x999.jpg', 1, '2021-12-18 14:27:29', '2021-12-18 14:27:29', 9);
INSERT INTO `product` VALUES (25, '连衣裙女新款2018秋款韩版小碎花裙子长袖文艺学生百搭小黑裙', '连衣裙女新款2018秋款韩版小碎花裙子长袖文艺学生百搭小黑裙', 97.00, 68.00, 'http://s11.mogucdn.com/mlcdn/c45406/170402_06ehihjk325cjc7jc4653k1bkek2b_640x960.jpg_560x999.jpg', 1, '2021-12-18 14:27:29', '2021-12-18 14:27:29', 10);
INSERT INTO `product` VALUES (26, '2018初秋新款BF港风网红学生复古小心机两件套装时尚女果绿宽松卫衣+休闲运动束脚裤子', '2018初秋新款BF港风网红学生复古小心机两件套装时尚女果绿宽松卫衣+休闲运动束脚裤子', 113.00, 79.00, 'http://s11.mogucdn.com/mlcdn/c45406/180802_686lie5edj192kc33ki737hle7d05_640x960.jpg_560x999.jpg', 1, '2021-12-18 14:27:29', '2021-12-18 14:27:29', NULL);
INSERT INTO `product` VALUES (27, '2018秋装新款韩版时尚套装chic暗红显白BF宽松显瘦冲锋衣外套+条杠休闲运动裤女两件套', '2018秋装新款韩版时尚套装chic暗红显白BF宽松显瘦冲锋衣外套+条杠休闲运动裤女两件套', 108.00, 76.00, 'http://s11.mogucdn.com/mlcdn/c45406/180819_2791931dhhb5h5bgik2cd6f4cc2ih_640x960.jpg_560x999.jpg', 1, '2021-12-18 14:27:29', '2021-12-18 14:27:29', 6);
INSERT INTO `product` VALUES (28, '2018早秋新款时尚套装女甜美韩版长袖子镂空拼接纯色衬衫+宽松显瘦割破牛仔背带裤两件套女', '2018早秋新款时尚套装女甜美韩版长袖子镂空拼接纯色衬衫+宽松显瘦割破牛仔背带裤两件套女', 99.00, 69.00, 'http://s3.mogucdn.com/mlcdn/c45406/180714_3gca7b9e5bc5ab4ldd76bh3712f07_640x960.jpg_560x999.jpg', 1, '2021-12-18 14:27:29', '2021-12-18 14:27:29', 7);
INSERT INTO `product` VALUES (29, '2018秋季新款时尚套装宽松BF风学生格子长袖衬衫女上衣+韩版百搭学院风牛仔背带裤女两件套', '2018秋季新款时尚套装宽松BF风学生格子长袖衬衫女上衣+韩版百搭学院风牛仔背带裤女两件套', 99.00, 69.00, 'http://s11.mogucdn.com/mlcdn/c45406/180812_5ejaf15h8i9182c1765lbf6464d8h_640x960.jpg_560x999.jpg', 1, '2021-12-18 14:27:29', '2021-12-18 14:27:29', 10);
INSERT INTO `product` VALUES (30, '2018秋冬装新款韩版宽松学生过膝ulzzang鱼尾裙长裙潮卫衣连衣裙女', '2018秋冬装新款韩版宽松学生过膝ulzzang鱼尾裙长裙潮卫衣连衣裙女', 140.00, 98.00, 'http://s11.mogucdn.com/mlcdn/c45406/180801_4jjj34129ai4a0fd062iibj8ig5il_640x960.jpg_560x999.jpg', 1, '2021-12-18 14:27:29', '2021-12-18 14:27:29', 9);
INSERT INTO `product` VALUES (31, '2018秋季新款韩版加肥加大码休闲服运动套装女胖mm两件套套装', '2018秋季新款韩版加肥加大码休闲服运动套装女胖mm两件套套装', 69.00, 69.00, 'http://s3.mogucdn.com/mlcdn/c45406/180810_17b3h5lg77ijc21680f7gkl6ffd25_640x960.jpg_560x999.jpg', 1, '2021-12-18 14:27:29', '2021-12-18 14:27:29', 8);
INSERT INTO `product` VALUES (32, '格姬2018秋装新款高腰连衣裙女七分袖复古超仙少女冷淡风收腰纯色系带中长裙6990', '格姬2018秋装新款高腰连衣裙女七分袖复古超仙少女冷淡风收腰纯色系带中长裙6990', 180.00, 126.00, 'http://s3.mogucdn.com/mlcdn/c45406/180816_5ddih74k67e17k63ji6d621cc363h_640x960.jpg_560x999.jpg', 1, '2021-12-18 14:27:29', '2021-12-18 14:27:29', 6);
INSERT INTO `product` VALUES (33, '2018秋季新款韩版BF宽松百搭显瘦开衫女+短款吊带小背心+高腰A字半身裙三件套时尚套装', '2018秋季新款韩版BF宽松百搭显瘦开衫女+短款吊带小背心+高腰A字半身裙三件套时尚套装', 184.00, 129.00, 'http://s3.mogucdn.com/mlcdn/c45406/180831_2dch37fcaak900247525i548lh393_640x960.jpg_560x999.jpg', 1, '2021-12-18 14:27:29', '2021-12-18 14:27:29', 10);
INSERT INTO `product` VALUES (34, '偏大大码秋装女套装新款2018中长款连帽卫衣+牛仔马甲洋气套装胖mm遮肉显瘦两件套省心搭配', '偏大大码秋装女套装新款2018中长款连帽卫衣+牛仔马甲洋气套装胖mm遮肉显瘦两件套省心搭配', 70.00, 49.00, 'http://s11.mogucdn.com/mlcdn/c45406/180821_7gccd889f8f88hde1kd4l99dj0h3e_640x960.jpg_560x999.jpg', 1, '2021-12-18 14:27:29', '2021-12-18 14:27:29', 8);
INSERT INTO `product` VALUES (35, '时尚OL女神套装2018秋季新款新款简约百搭衬衫高腰时髦条纹哈伦裤两件套女', '时尚OL女神套装2018秋季新款新款简约百搭衬衫高腰时髦条纹哈伦裤两件套女', 140.00, 98.00, 'http://s11.mogucdn.com/mlcdn/c45406/180829_2kkjklb37965g608kk717ab0i7579_640x960.jpg_560x999.jpg', 1, '2021-12-18 14:27:29', '2021-12-18 14:27:29', 5);
INSERT INTO `product` VALUES (36, '时尚套装2018春季新款牛仔短款外套时尚外套气质上衣女+高腰显瘦直筒大口袋牛仔裤两件套', '时尚套装2018春季新款牛仔短款外套时尚外套气质上衣女+高腰显瘦直筒大口袋牛仔裤两件套', 70.00, 49.00, 'http://s11.mogucdn.com/mlcdn/c45406/180302_5e2jjb9cfkkfbkcb2hd8j02eef478_640x960.jpg_560x999.jpg', 1, '2021-12-18 14:27:29', '2021-12-18 14:27:29', 10);
INSERT INTO `product` VALUES (37, '2018秋季新款时尚套装韩范宽松BF字母学院风工装风衣外套修身显瘦小脚裤套装两件套女', '2018秋季新款时尚套装韩范宽松BF字母学院风工装风衣外套修身显瘦小脚裤套装两件套女', 71.00, 50.00, 'http://s3.mogucdn.com/p2/170210/176681490_7hac00i68kadaed0i6ba8l3le5dd3_640x960.jpg_560x999.jpg', 1, '2021-12-18 14:27:29', '2021-12-18 14:27:29', 6);
INSERT INTO `product` VALUES (38, '2018秋装新款时尚高领收腰显瘦针织连衣裙中长款毛衣裙长款', '2018秋装新款时尚高领收腰显瘦针织连衣裙中长款毛衣裙长款', 414.00, 414.00, 'http://s11.mogucdn.com/mlcdn/55cf19/180816_3905kfkkfg63ja251869ljll7j93h_640x960.jpg_560x999.jpg', 1, '2021-12-18 14:27:29', '2021-12-18 14:27:29', NULL);
INSERT INTO `product` VALUES (39, '2018秋季新款三件套韩版拼色针织开衫中长款毛衣外套+小清新格子衬衫+显瘦牛仔裤时尚套装', '2018秋季新款三件套韩版拼色针织开衫中长款毛衣外套+小清新格子衬衫+显瘦牛仔裤时尚套装', 84.00, 59.00, 'http://s11.mogucdn.com/mlcdn/c45406/180801_8filh47j1lh24a8a6500dj46ie597_640x854.jpg_560x999.jpg', 1, '2021-12-18 14:27:29', '2021-12-18 14:27:29', 5);
INSERT INTO `product` VALUES (40, '2018秋季新款时尚套装半透明雪纺衫V领破洞针织马甲呢子休闲裤套装三件套', '2018秋季新款时尚套装半透明雪纺衫V领破洞针织马甲呢子休闲裤套装三件套', 84.00, 59.00, 'http://s11.mogucdn.com/mlcdn/c45406/180120_1dl4a4dljdg8eclkef40kl1ke8g7k_640x960.jpg_560x999.jpg', 1, '2021-12-18 14:27:29', '2021-12-18 14:27:29', 5);
INSERT INTO `product` VALUES (41, '休闲运动服套装女春秋季2018新款韩版时尚大码宽松长袖卫衣三件套', '休闲运动服套装女春秋季2018新款韩版时尚大码宽松长袖卫衣三件套', 138.00, 138.00, 'http://s11.mogucdn.com/mlcdn/c45406/180807_3e09gg2fl5456hh9chli29d66j9ji_640x960.jpg_560x999.jpg', 1, '2021-12-18 14:27:29', '2021-12-18 14:27:29', 10);
INSERT INTO `product` VALUES (42, '2018秋季新款韩版时尚套装红格子长袖衬衫+百搭显瘦吊带针织连衣裙两件套女', '2018秋季新款韩版时尚套装红格子长袖衬衫+百搭显瘦吊带针织连衣裙两件套女', 168.00, 79.00, 'http://s11.mogucdn.com/mlcdn/c45406/180307_6c7j5el2b184dgcf244k8253cik56_640x832.jpg_560x999.jpg', 1, '2021-12-18 14:27:29', '2021-12-18 14:27:29', NULL);
INSERT INTO `product` VALUES (43, '定制2018秋季欧洲新款雪纺复古挂脖V领长袖衬衫中长款港味半身裙时尚套装女装', '定制2018秋季欧洲新款雪纺复古挂脖V领长袖衬衫中长款港味半身裙时尚套装女装', 101.00, 71.00, 'http://s11.mogucdn.com/mlcdn/c45406/170907_2efhlkeke21efd84lf20e4kac70f1_1200x1800.jpg_560x999.jpg', 1, '2021-12-18 14:27:29', '2021-12-18 14:27:29', 5);
INSERT INTO `product` VALUES (44, '晚晚风黑色连衣裙2018秋装新款女装韩版显瘦中长款V领A字裙赫本小黑裙气质百搭中长款连衣裙', '晚晚风黑色连衣裙2018秋装新款女装韩版显瘦中长款V领A字裙赫本小黑裙气质百搭中长款连衣裙', 179.00, 69.00, 'http://s3.mogucdn.com/mlcdn/c45406/180903_61lihh46bg9k4ej5ddia841338284_640x960.jpg_560x999.jpg', 1, '2021-12-18 14:27:29', '2021-12-18 14:27:29', 7);
INSERT INTO `product` VALUES (45, '2018秋季新款时尚套装韩版百搭个性拼色格纹套头连帽卫衣高腰显瘦休闲裤两件套', '2018秋季新款时尚套装韩版百搭个性拼色格纹套头连帽卫衣高腰显瘦休闲裤两件套', 99.00, 69.00, 'http://s11.mogucdn.com/mlcdn/c45406/180906_3d610k09hge16h62gg2h5h4fg2ali_640x960.jpg_560x999.jpg', 1, '2021-12-18 14:27:29', '2021-12-18 14:27:29', 9);
INSERT INTO `product` VALUES (46, '秋季2018新款韩版毛边剪裁单排扣洗水牛仔外套抽绳连帽显瘦卫衣裙子秋装时尚套装两件套女装', '秋季2018新款韩版毛边剪裁单排扣洗水牛仔外套抽绳连帽显瘦卫衣裙子秋装时尚套装两件套女装', 127.00, 89.00, 'http://s3.mogucdn.com/mlcdn/c45406/180823_5ifd9g28613bi7c10jjk866ki2l32_640x960.jpg_560x999.jpg', 1, '2021-12-18 14:27:29', '2021-12-18 14:27:29', 9);
INSERT INTO `product` VALUES (47, '2018秋季新款韩版学院风长袖条纹上衣女高腰直筒牛仔背带裤衣裤时尚套装两件套', '2018秋季新款韩版学院风长袖条纹上衣女高腰直筒牛仔背带裤衣裤时尚套装两件套', 70.00, 49.00, 'http://s3.mogucdn.com/mlcdn/55cf19/180902_77hklal614d182bl9725ad5gbfil2_640x960.jpg_560x999.jpg', 1, '2021-12-18 14:27:29', '2021-12-18 14:27:29', NULL);
INSERT INTO `product` VALUES (48, '2018秋季新款时尚套装连帽卫衣女休闲针织运动裤套装两件套女', '2018秋季新款时尚套装连帽卫衣女休闲针织运动裤套装两件套女', 99.00, 69.00, 'http://s3.mogucdn.com/mlcdn/c45406/180103_6h04c282hf39913aje7434e1ie9c6_640x960.jpg_560x999.jpg', 1, '2021-12-18 14:27:29', '2021-12-18 14:27:29', 10);
INSERT INTO `product` VALUES (49, '2018早秋季韩版百搭学生修身显瘦长袖t恤女秋冬新款原宿风圆领卡通刺绣纯棉打底衫上衣服体恤', '2018早秋季韩版百搭学生修身显瘦长袖t恤女秋冬新款原宿风圆领卡通刺绣纯棉打底衫上衣服体恤', 64.00, 45.00, 'http://s11.mogucdn.com/mlcdn/c45406/180821_2a6ek98i3jj902h50i7h7ekf0agj3_640x960.jpg_560x999.jpg', 1, '2021-12-18 14:27:29', '2021-12-18 14:27:29', 8);
INSERT INTO `product` VALUES (50, '套装两件套2018初秋秋季新款长款薄款卫衣外套+高腰格子半身裙中长款打底裙网红套装', '套装两件套2018初秋秋季新款长款薄款卫衣外套+高腰格子半身裙中长款打底裙网红套装', 86.00, 60.00, 'http://s11.mogucdn.com/mlcdn/c45406/180729_02fl1g7c873825e5fhc76ba3h2505_640x960.jpg_560x999.jpg', 1, '2021-12-18 14:27:29', '2021-12-18 14:27:29', 9);
INSERT INTO `product` VALUES (51, '秋季新款百搭学生闺蜜装V领长袖竹节棉t恤女2018秋冬韩版宽松显瘦纯色打底衫短款上衣服体恤', '秋季新款百搭学生闺蜜装V领长袖竹节棉t恤女2018秋冬韩版宽松显瘦纯色打底衫短款上衣服体恤', 64.00, 45.00, 'http://s11.mogucdn.com/mlcdn/c45406/180822_5d29k4j5g79jg043f591f6igbcdg6_640x960.jpg_560x999.jpg', 1, '2021-12-18 14:27:29', '2021-12-18 14:27:29', 5);
INSERT INTO `product` VALUES (52, '2018秋装新款ins超火韩版女装微喇叭裤女九分裤高腰显瘦弹力微喇裤黑色薄款修身阔腿休闲裤', '2018秋装新款ins超火韩版女装微喇叭裤女九分裤高腰显瘦弹力微喇裤黑色薄款修身阔腿休闲裤', 108.00, 108.00, 'http://s11.mogucdn.com/mlcdn/c45406/180316_0l422k59b28kf6ef1h5i2j0g25ba8_1000x1498.jpg_560x999.jpg', 1, '2021-12-18 14:27:29', '2021-12-18 14:27:29', 9);
INSERT INTO `product` VALUES (53, '秋季网红女时尚两件套2018新款晚晚风气质女神范针织港味套装裙子', '秋季网红女时尚两件套2018新款晚晚风气质女神范针织港味套装裙子', 140.00, 98.00, 'http://s3.mogucdn.com/mlcdn/c45406/180812_7dg023gflle285h71f1kf8gfi588i_640x960.jpg_560x999.jpg', 1, '2021-12-18 14:27:29', '2021-12-18 14:27:29', 8);
INSERT INTO `product` VALUES (54, '2018外套女秋季新款女装时尚套装韩版拼色针织开衫中长款毛衣外套小清新格子衬衫牛仔裤三件套', '2018外套女秋季新款女装时尚套装韩版拼色针织开衫中长款毛衣外套小清新格子衬衫牛仔裤三件套', 77.00, 54.00, 'http://s11.mogucdn.com/mlcdn/c45406/180316_16k6dj8ff3ka9ci31djgj9999a985_640x960.jpg_560x999.jpg', 1, '2021-12-18 14:27:29', '2021-12-18 14:27:29', 7);
INSERT INTO `product` VALUES (55, '2018春秋季新款韩版百搭连帽卫衣+松紧腰长裤时尚运动套装两件套女学生', '2018春秋季新款韩版百搭连帽卫衣+松紧腰长裤时尚运动套装两件套女学生', 57.00, 57.00, 'http://s3.mogucdn.com/mlcdn/c45406/170823_0d997dch3jkl8ed225ejbba76j2lf_640x832.jpg_560x999.jpg', 1, '2021-12-18 14:27:29', '2021-12-18 14:27:29', NULL);
INSERT INTO `product` VALUES (56, '2018春秋新款韩版胖mm加肥加大码200斤刺绣字母打底衫宽松显瘦长袖t恤上衣', '2018春秋新款韩版胖mm加肥加大码200斤刺绣字母打底衫宽松显瘦长袖t恤上衣', 47.00, 47.00, 'http://s11.mogucdn.com/mlcdn/17f85e/180923_7b30c16he2lfdidb6e826kih8eaki_640x960.jpg_560x999.jpg', 1, '2021-12-18 14:27:29', '2021-12-18 14:27:29', 10);
INSERT INTO `product` VALUES (57, '2018秋新款飞鹰烫金印花字母纯棉潮牌情侣小脚裤男女同款', '2018秋新款飞鹰烫金印花字母纯棉潮牌情侣小脚裤男女同款', 226.00, 158.00, 'http://s3.mogucdn.com/mlcdn/c45406/180922_05jafg8g5k7flkj35icg400b0l4k7_800x1200.jpg_560x999.jpg', 1, '2021-12-18 14:27:29', '2021-12-18 14:27:29', 7);
INSERT INTO `product` VALUES (58, '万年经典条纹上衣女装秋2018韩版新款宽松百搭显瘦拼色条纹长袖T恤女学生原宿慵懒风', '万年经典条纹上衣女装秋2018韩版新款宽松百搭显瘦拼色条纹长袖T恤女学生原宿慵懒风', 70.00, 70.00, 'http://s11.mogucdn.com/mlcdn/55cf19/180926_7078259k7h0l2ihf67k2hc7ca79ic_640x960.jpg_560x999.jpg', 1, '2021-12-18 14:27:29', '2021-12-18 14:27:29', 8);
INSERT INTO `product` VALUES (59, '秋冬新款V领撞色条纹长袖打底衫宽松短款上衣小衫2018秋季韩版百搭学生闺蜜装显瘦纯棉t恤女', '秋冬新款V领撞色条纹长袖打底衫宽松短款上衣小衫2018秋季韩版百搭学生闺蜜装显瘦纯棉t恤女', 64.00, 45.00, 'http://s3.mogucdn.com/mlcdn/c45406/180808_830ji849kbjbci113j19e11igkf44_640x960.jpg_560x999.jpg', 1, '2021-12-18 14:27:29', '2021-12-18 14:27:29', 6);
INSERT INTO `product` VALUES (60, '秋季2018新款百搭学生闺蜜装V领长袖条纹打底衫宽松上衣秋冬韩版修身显瘦短款纯棉t恤女小衫', '秋季2018新款百搭学生闺蜜装V领长袖条纹打底衫宽松上衣秋冬韩版修身显瘦短款纯棉t恤女小衫', 64.00, 45.00, 'http://s3.mogucdn.com/mlcdn/c45406/180807_43jj257hd8gd5g04605957la67f6j_640x960.jpg_560x999.jpg', 1, '2021-12-18 14:27:29', '2021-12-18 14:27:29', 10);
INSERT INTO `product` VALUES (61, '2018秋季新款格子衬衫女长袖韩版复古灯笼袖学生宽松泡泡袖大码娃娃衫B24', '2018秋季新款格子衬衫女长袖韩版复古灯笼袖学生宽松泡泡袖大码娃娃衫B24', 99.00, 99.00, 'http://s3.mogucdn.com/mlcdn/c45406/180803_7ed1i8bkhlgkdh733j724ed22a0fh_640x960.jpg_560x999.jpg', 1, '2021-12-18 14:27:29', '2021-12-18 14:27:29', 8);
INSERT INTO `product` VALUES (62, '纯棉撞色条纹V领纯棉t恤女2018秋季新款韩版学生闺蜜装百搭修身显瘦长袖打底衫宽松上衣小衫', '纯棉撞色条纹V领纯棉t恤女2018秋季新款韩版学生闺蜜装百搭修身显瘦长袖打底衫宽松上衣小衫', 64.00, 45.00, 'http://s3.mogucdn.com/mlcdn/c45406/180808_61dc0ici7c6bbe65cii22c31513i6_640x960.jpg_560x999.jpg', 1, '2021-12-18 14:27:29', '2021-12-18 14:27:29', 7);
INSERT INTO `product` VALUES (63, '秋季2018新款韩版条纹T恤女长袖宽松学生百搭小清新打底衫原宿风慵懒港味上衣服', '秋季2018新款韩版条纹T恤女长袖宽松学生百搭小清新打底衫原宿风慵懒港味上衣服', 68.00, 68.00, 'http://s11.mogucdn.com/mlcdn/55cf19/180926_1j176fab5g21kd3ib9jlgj751dcgh_640x960.jpg_560x999.jpg', 1, '2021-12-18 14:27:29', '2021-12-18 14:27:29', 7);
INSERT INTO `product` VALUES (64, '秋季2018新款韩版宽松开衫连帽长袖卫衣外套吊带裙背心裙显瘦连衣裙子时尚套装秋装两件套女装', '秋季2018新款韩版宽松开衫连帽长袖卫衣外套吊带裙背心裙显瘦连衣裙子时尚套装秋装两件套女装', 127.00, 89.00, 'http://s3.mogucdn.com/mlcdn/c45406/180827_8aa0ajci5142eic7lj870jlhe26gg_640x960.jpg_560x999.jpg', 1, '2021-12-18 14:27:29', '2021-12-18 14:27:29', 5);
INSERT INTO `product` VALUES (65, '2018外套女秋季新款女装时尚套装女韩版中长款卫衣开衫外套高腰显瘦开叉小脚裤子套装两件套', '2018外套女秋季新款女装时尚套装女韩版中长款卫衣开衫外套高腰显瘦开叉小脚裤子套装两件套', 86.00, 60.00, 'http://s3.mogucdn.com/mlcdn/c45406/180109_85ee34ae6197i5k44ig69c1gd22ak_640x960.jpg_560x999.jpg', 1, '2021-12-18 14:27:29', '2021-12-18 14:27:29', 6);
INSERT INTO `product` VALUES (66, '网红同款2018秋冬新款女装韩版气质时髦秋季chic风毛衣套装裙两件套时尚潮', '网红同款2018秋冬新款女装韩版气质时髦秋季chic风毛衣套装裙两件套时尚潮', 185.00, 130.00, 'http://s3.mogucdn.com/mlcdn/c45406/180802_1ec122l9ii2gj8l2fjck6f5f00eke_640x960.jpg_560x999.jpg', 1, '2021-12-18 14:27:29', '2021-12-18 14:27:29', NULL);
INSERT INTO `product` VALUES (67, '韩风chic上衣2018新款秋季韩版学院风日系软妹小清新拼色V领百搭长袖t恤卫衣女学生', '韩风chic上衣2018新款秋季韩版学院风日系软妹小清新拼色V领百搭长袖t恤卫衣女学生', 60.00, 60.00, 'http://s3.mogucdn.com/mlcdn/55cf19/180923_8870522k681i85d2gfi1k6le1382e_640x960.jpg_560x999.jpg', 1, '2021-12-18 14:27:29', '2021-12-18 14:27:29', 9);
INSERT INTO `product` VALUES (68, '2018秋装女装韩版新款套装两件套时尚性感时尚套装上衣女+运动裤子套装女潮显瘦宽松', '2018秋装女装韩版新款套装两件套时尚性感时尚套装上衣女+运动裤子套装女潮显瘦宽松', 198.00, 198.00, 'http://s3.mogucdn.com/mlcdn/c45406/180826_5cf0l1745i7hl39dgeb3di3hc3af1_640x960.jpg_560x999.jpg', 1, '2021-12-18 14:27:29', '2021-12-18 14:27:29', 8);
INSERT INTO `product` VALUES (69, '吊带背心女2018夏季新款内穿外穿打底背心裹胸韩版学生吊带打底衫', '吊带背心女2018夏季新款内穿外穿打底背心裹胸韩版学生吊带打底衫', 43.00, 43.00, 'http://s3.mogucdn.com/mlcdn/c45406/180927_245533i8jdjf722f654lee42ae12i_640x960.jpg_560x999.jpg', 1, '2021-12-18 14:27:29', '2021-12-18 14:27:29', NULL);
INSERT INTO `product` VALUES (70, '2018外套女秋季新款女装时尚套装女韩版针织开衫毛衣外套格子衬衫直筒牛仔裤子套装三件套', '2018外套女秋季新款女装时尚套装女韩版针织开衫毛衣外套格子衬衫直筒牛仔裤子套装三件套', 77.00, 54.00, 'http://s3.mogucdn.com/mlcdn/c45406/171224_57ldck1ki0bjh0fc48ac0e2f9i788_640x960.jpg_560x999.jpg', 1, '2021-12-18 14:27:29', '2021-12-18 14:27:29', NULL);
INSERT INTO `product` VALUES (71, '带帽运动服2018秋冬新款韩版时尚加厚刺绣金丝绒女士宽松休闲连帽运动服卫衣两件套潮', '带帽运动服2018秋冬新款韩版时尚加厚刺绣金丝绒女士宽松休闲连帽运动服卫衣两件套潮', 129.00, 129.00, 'http://s3.mogucdn.com/mlcdn/55cf19/180923_3jbhe3i9907eii29bl70b07lkdkck_640x960.jpg_560x999.jpg', 1, '2021-12-18 14:27:29', '2021-12-18 14:27:29', 5);
INSERT INTO `product` VALUES (72, '2018秋季新款时尚套装学院风V领小清新毛衣针织衫百搭格子衬衫显瘦小脚牛仔裤套装三件套', '2018秋季新款时尚套装学院风V领小清新毛衣针织衫百搭格子衬衫显瘦小脚牛仔裤套装三件套', 84.00, 59.00, 'http://s11.mogucdn.com/mlcdn/c45406/180226_3gg8h809bf7eg08gl0fl40b38e958_640x960.jpg_560x999.jpg', 1, '2021-12-18 14:27:29', '2021-12-18 14:27:29', 6);
INSERT INTO `product` VALUES (73, '【秋冬加厚】灯芯绒2018新品百搭休闲裤女韩版毛呢裤子高腰显瘦宽松九分哈伦裤条纹大码小脚裤', '【秋冬加厚】灯芯绒2018新品百搭休闲裤女韩版毛呢裤子高腰显瘦宽松九分哈伦裤条纹大码小脚裤', 99.00, 55.00, 'http://s11.mogucdn.com/mlcdn/17f85e/180926_76fee3df733b8h463gaj3lg6592bb_640x960.jpg_560x999.jpg', 1, '2021-12-18 14:27:29', '2021-12-18 14:27:29', NULL);
INSERT INTO `product` VALUES (74, '2018新款秋装女装上衣服原宿风百搭时尚胖妹妹姐妹装体恤衫韩版女学生闺蜜装大码简约印花t恤', '2018新款秋装女装上衣服原宿风百搭时尚胖妹妹姐妹装体恤衫韩版女学生闺蜜装大码简约印花t恤', 40.00, 40.00, 'http://s3.mogucdn.com/mlcdn/55cf19/180823_657b62gkeca17eb91h6j9c8k1h8le_640x960.jpg_560x999.jpg', 1, '2021-12-18 14:27:29', '2021-12-18 14:27:29', 6);
INSERT INTO `product` VALUES (75, '2018新款半高领打底衫女装秋冬中领长袖t恤修身黑色纯棉紧身上衣', '2018新款半高领打底衫女装秋冬中领长袖t恤修身黑色纯棉紧身上衣', 85.00, 85.00, 'http://s3.mogucdn.com/mlcdn/c45406/180830_83cka4ghle20j90i5455j1i7li77k_640x960.jpg_560x999.jpg', 1, '2021-12-18 14:27:29', '2021-12-18 14:27:29', 6);
INSERT INTO `product` VALUES (76, '夏装2018新款韩版修身小吊带背心女学生显瘦内穿无袖打底衫上衣女', '夏装2018新款韩版修身小吊带背心女学生显瘦内穿无袖打底衫上衣女', 43.00, 43.00, 'http://s3.mogucdn.com/mlcdn/c45406/180927_23414d50hejlg647efd36j6j66jdl_640x960.jpg_560x999.jpg', 1, '2021-12-18 14:27:29', '2021-12-18 14:27:29', 6);
INSERT INTO `product` VALUES (77, '2018秋季新款韩版女装字母印花宽松连帽休闲卫衣搭配松紧腰九分牛仔裤两件套女时尚运动套装潮', '2018秋季新款韩版女装字母印花宽松连帽休闲卫衣搭配松紧腰九分牛仔裤两件套女时尚运动套装潮', 97.00, 68.00, 'http://s11.mogucdn.com/mlcdn/c45406/180811_1k5hfa6d803575df3lkb6j67l5j3c_640x960.jpg_560x999.jpg', 1, '2021-12-18 14:27:29', '2021-12-18 14:27:29', 9);
INSERT INTO `product` VALUES (78, '复古黑白格子衬衫2018春季新款女装韩范宽松版百搭上衣软妹格纹衬衣', '复古黑白格子衬衫2018春季新款女装韩范宽松版百搭上衣软妹格纹衬衣', 71.00, 50.00, 'http://s11.mogucdn.com/mlcdn/c45406/180911_550eg3ghe4cgj89jk0lk19la32lf9_640x960.jpg_560x999.jpg', 1, '2021-12-18 14:27:29', '2021-12-18 14:27:29', 10);
INSERT INTO `product` VALUES (79, '【2件69元】【新品特惠】短袖t恤女2018夏装新款韩版学生宽松黑色体恤圆领纯棉半袖上衣服', '【2件69元】【新品特惠】短袖t恤女2018夏装新款韩版学生宽松黑色体恤圆领纯棉半袖上衣服', 70.00, 49.00, 'http://s3.mogucdn.com/mlcdn/c45406/180301_784ej0g6c8dca24fa2c8dlfhe0fgc_640x960.jpg_560x999.jpg', 1, '2021-12-18 14:27:29', '2021-12-18 14:27:29', 8);
INSERT INTO `product` VALUES (80, '2018夏季新款女装复古港味性感波点挂脖两穿学生打底抹胸小吊带背心女', '2018夏季新款女装复古港味性感波点挂脖两穿学生打底抹胸小吊带背心女', 57.00, 57.00, 'http://s3.mogucdn.com/mlcdn/c45406/180621_1h968hc9g2if464j0ld1fc0jc3492_640x960.jpg_560x999.jpg', 1, '2021-12-18 14:27:29', '2021-12-18 14:27:29', 9);
INSERT INTO `product` VALUES (81, '2018长袖t恤春秋季新款韩版怪味少女学生宽松显瘦嘻哈ins超火女生酷酷的上衣服潮', '2018长袖t恤春秋季新款韩版怪味少女学生宽松显瘦嘻哈ins超火女生酷酷的上衣服潮', 40.00, 40.00, 'http://s11.mogucdn.com/mlcdn/55cf19/180823_4dgk20j7dgb5ef9abij8fd9aaah5a_640x960.jpg_560x999.jpg', 1, '2021-12-18 14:27:29', '2021-12-18 14:27:29', NULL);
INSERT INTO `product` VALUES (82, '时尚套装女2018秋冬新款百搭毛衣女+时尚宽松显瘦牛仔背带裤', '时尚套装女2018秋冬新款百搭毛衣女+时尚宽松显瘦牛仔背带裤', 99.00, 69.00, 'http://s3.mogucdn.com/mlcdn/55cf19/180822_891ag27iicc1kl0fa93l0iddg45c3_640x960.jpg_560x999.jpg', 1, '2021-12-18 14:27:29', '2021-12-18 14:27:29', 10);
INSERT INTO `product` VALUES (83, '2018韩版秋季新款学院风猫咪刺绣宽松显瘦牛仔背带裤+宽松织带条纹毛衣时尚衣裤套装女', '2018韩版秋季新款学院风猫咪刺绣宽松显瘦牛仔背带裤+宽松织带条纹毛衣时尚衣裤套装女', 99.00, 69.00, 'http://s11.mogucdn.com/mlcdn/55cf19/180804_4l05750fhlbhhj1g6jb4075cife3l_640x960.jpg_560x999.jpg', 1, '2021-12-18 14:27:29', '2021-12-18 14:27:29', 8);
INSERT INTO `product` VALUES (84, '2018新款韩版纯棉V领条纹长袖体恤女装上衣服修身显瘦打底衫女式时尚T恤女生潮', '2018新款韩版纯棉V领条纹长袖体恤女装上衣服修身显瘦打底衫女式时尚T恤女生潮', 55.00, 38.00, 'http://s3.mogucdn.com/mlcdn/17f85e/180830_3c8f1g7hka41603lfl25gh32b860i_640x960.jpg_560x999.jpg', 1, '2021-12-18 14:27:29', '2021-12-18 14:27:29', 9);
INSERT INTO `product` VALUES (85, '2018新款秋装白色长袖t恤女宽松韩版学生体恤百搭长袖上衣服', '2018新款秋装白色长袖t恤女宽松韩版学生体恤百搭长袖上衣服', 57.00, 40.00, 'http://s11.mogucdn.com/mlcdn/55cf19/180809_00j78l8dakkgjkk2a3lgfeae1kgj1_640x960.jpg_560x999.jpg', 1, '2021-12-18 14:27:29', '2021-12-18 14:27:29', 7);
INSERT INTO `product` VALUES (86, '2018秋冬新款韩版宽松喇叭袖针织毛衣+时尚潮流黑色显瘦牛仔背带裤套装两件套', '2018秋冬新款韩版宽松喇叭袖针织毛衣+时尚潮流黑色显瘦牛仔背带裤套装两件套', 99.00, 69.00, 'http://s11.mogucdn.com/mlcdn/55cf19/180901_2k0g5i06kcllef7jdehe9jd15kc2i_640x960.jpg_560x999.jpg', 1, '2021-12-18 14:27:29', '2021-12-18 14:27:29', 7);
INSERT INTO `product` VALUES (87, '2018秋季新款宽松中长款印花卫衣女+包臀开叉半身裙套装两件套', '2018秋季新款宽松中长款印花卫衣女+包臀开叉半身裙套装两件套', 84.00, 59.00, 'http://s11.mogucdn.com/mlcdn/55cf19/180901_09l36d4lhdf10if8g5cl877df973j_640x960.jpg_560x999.jpg', 1, '2021-12-18 14:27:29', '2021-12-18 14:27:29', 6);
INSERT INTO `product` VALUES (88, '加绒加厚裤子女秋冬2018新款学生韩版宽松显瘦休闲哈伦运动卫裤秋', '加绒加厚裤子女秋冬2018新款学生韩版宽松显瘦休闲哈伦运动卫裤秋', 49.00, 49.00, 'http://s11.mogucdn.com/mlcdn/55cf19/180925_6bdiibf87e046d836dcjie5l40fk1_641x641.jpg_560x999.jpg', 1, '2021-12-18 14:27:29', '2021-12-18 14:27:29', 5);
INSERT INTO `product` VALUES (89, '裤子女阔腿裤春秋2018新款毛呢裤九分裤港味潮女裤甩腿裤女士裤子', '裤子女阔腿裤春秋2018新款毛呢裤九分裤港味潮女裤甩腿裤女士裤子', 70.00, 70.00, 'http://s11.mogucdn.com/mlcdn/c45406/180826_5708i53lg6ifcgd7402ieg99ab77b_640x640.jpg_560x999.jpg', 1, '2021-12-18 14:27:29', '2021-12-18 14:27:29', 10);
INSERT INTO `product` VALUES (90, '2018秋季新款时尚套装韩版菱格针织开衫女宽松学生毛衣外套高腰休闲裤套装两件套', '2018秋季新款时尚套装韩版菱格针织开衫女宽松学生毛衣外套高腰休闲裤套装两件套', 99.00, 69.00, 'http://s3.mogucdn.com/mlcdn/c45406/180225_6i3kjj16b3g4c5fgb9a445l2bj5f0_640x960.jpg_560x999.jpg', 1, '2021-12-18 14:27:29', '2021-12-18 14:27:29', 9);
INSERT INTO `product` VALUES (91, '【59元2件】条纹纯棉运动短裤女2018春夏新款韩版宽松显瘦休闲裤学生跑步三分裤', '【59元2件】条纹纯棉运动短裤女2018春夏新款韩版宽松显瘦休闲裤学生跑步三分裤', 50.00, 35.00, 'http://s3.mogucdn.com/mlcdn/c45406/180522_21l7lb0acallifbl6d6ael74h45c3_640x960.jpg_560x999.jpg', 1, '2021-12-18 14:27:29', '2021-12-18 14:27:29', 9);
INSERT INTO `product` VALUES (92, '2018秋季新款韩版百搭格子长袖衬衫+前短后长针织气质开衫外套+高腰直筒九分牛仔裤三件套装', '2018秋季新款韩版百搭格子长袖衬衫+前短后长针织气质开衫外套+高腰直筒九分牛仔裤三件套装', 84.00, 59.00, 'http://s3.mogucdn.com/mlcdn/c45406/180808_600abce0g8dc8i4f6ic7k27i7837l_640x960.jpg_560x999.jpg', 1, '2021-12-18 14:27:29', '2021-12-18 14:27:29', 10);
INSERT INTO `product` VALUES (93, '2018新款秋装衬衫+收腰马甲+休闲裤名媛超火时尚套装女洋气三件套女J14', '2018新款秋装衬衫+收腰马甲+休闲裤名媛超火时尚套装女洋气三件套女J14', 157.00, 110.00, 'http://s3.mogucdn.com/mlcdn/c45406/180813_587cl37ikbj5ah47lbi0c098eehk4_640x960.jpg_560x999.jpg', 1, '2021-12-18 14:27:29', '2021-12-18 14:27:29', 10);
INSERT INTO `product` VALUES (94, '黑色半高领打底衫女修身长袖上衣秋冬百搭中领纯棉秋衣2018春秋新款薄', '黑色半高领打底衫女修身长袖上衣秋冬百搭中领纯棉秋衣2018春秋新款薄', 85.00, 60.00, 'http://s11.mogucdn.com/mlcdn/c45406/180730_697eaeelf9g5e41j5f52b14ggej8f_640x960.jpg_560x999.jpg', 1, '2021-12-18 14:27:29', '2021-12-18 14:27:29', 8);
INSERT INTO `product` VALUES (95, '2018夏季新款韩版丝绸粉色ins超火丝滑德芙束腿九分裤休闲运动裤女潮', '2018夏季新款韩版丝绸粉色ins超火丝滑德芙束腿九分裤休闲运动裤女潮', 70.00, 49.00, 'http://s11.mogucdn.com/mlcdn/c45406/180517_45lgaj2gf08h8egc4820ek82bi18i_640x960.jpg_560x999.jpg', 1, '2021-12-18 14:27:29', '2021-12-18 14:27:29', 7);
INSERT INTO `product` VALUES (96, '现货秒发~2018春秋新款套装条纹衬衫不规则拼接V领破马甲烟灰色铅笔小脚牛仔裤套装三件套', '现货秒发~2018春秋新款套装条纹衬衫不规则拼接V领破马甲烟灰色铅笔小脚牛仔裤套装三件套', 99.00, 69.00, 'http://s11.mogucdn.com/mlcdn/c45406/170925_1kjjfb8iae7dcdjgc131l246bki3l_640x960.jpg_560x999.jpg', 1, '2021-12-18 14:27:29', '2021-12-18 14:27:29', 9);
INSERT INTO `product` VALUES (97, '2018秋季新款时尚套装宽松海马毛毛衣女学院风百搭黑色牛仔背带裤两件套', '2018秋季新款时尚套装宽松海马毛毛衣女学院风百搭黑色牛仔背带裤两件套', 99.00, 69.00, 'http://s3.mogucdn.com/mlcdn/55cf19/180903_2ahjib119c3433ehidb4lf7k9f9g3_640x960.jpg_560x999.jpg', 1, '2021-12-18 14:27:29', '2021-12-18 14:27:29', 5);
INSERT INTO `product` VALUES (98, '【两件79元】半高领打底衫女2018新款秋冬白色加绒加厚紧身长袖t恤韩版ins超火的上衣', '【两件79元】半高领打底衫女2018新款秋冬白色加绒加厚紧身长袖t恤韩版ins超火的上衣', 49.00, 49.00, 'http://s11.mogucdn.com/mlcdn/c45406/180915_6d523b1i35c6873a212396j3c1652_800x800.jpg_560x999.jpg', 1, '2021-12-18 14:27:29', '2021-12-18 14:27:29', 5);
INSERT INTO `product` VALUES (99, '运动套装女春秋韩版2018新款女装春装时髦休闲衣服薄款卫衣两件套', '运动套装女春秋韩版2018新款女装春装时髦休闲衣服薄款卫衣两件套', 79.00, 79.00, 'http://s11.mogucdn.com/mlcdn/c45406/180226_2hb2b3991i5kj050e4c9cfk985ab2_800x800.jpg_560x999.jpg', 1, '2021-12-18 14:27:29', '2021-12-18 14:27:29', 7);
INSERT INTO `product` VALUES (100, '秋装女2018新款套装时尚晚晚风气质chic港味女神网红两件套装俏皮', '秋装女2018新款套装时尚晚晚风气质chic港味女神网红两件套装俏皮', 156.00, 109.00, 'http://s11.mogucdn.com/mlcdn/c45406/180827_1590j44g2bk619i6655ji20ihikfb_640x960.jpg_560x999.jpg', 1, '2021-12-18 14:27:29', '2021-12-18 14:27:29', 5);
INSERT INTO `product` VALUES (101, '早秋新款2018韩版ins超火港风条纹长袖雪纺衬衫气质百搭宽松显瘦chic上衣慵懒衬衣女潮', '早秋新款2018韩版ins超火港风条纹长袖雪纺衬衫气质百搭宽松显瘦chic上衣慵懒衬衣女潮', 150.00, 39.00, 'http://s11.mogucdn.com/mlcdn/55cf19/180911_77hkba33lh2k52al9h406j8fl6ead_798x1197.jpg_560x999.jpg', 1, '2021-12-18 14:27:29', '2021-12-18 14:27:29', 6);
INSERT INTO `product` VALUES (102, '2018春夏新款韩范长袖白色衬衫女百搭宽松中长款棉麻立领韩版打底衬衣', '2018春夏新款韩范长袖白色衬衫女百搭宽松中长款棉麻立领韩版打底衬衣', 70.00, 49.00, 'http://s3.mogucdn.com/mlcdn/c45406/180514_15272difihj7hg63gkakkg00hciaf_640x960.jpg_560x999.jpg', 1, '2021-12-18 14:27:29', '2021-12-18 14:27:29', 8);
INSERT INTO `product` VALUES (103, '2018春夏新款女装宽松潮V领破洞镂空字母印花短袖T恤', '2018春夏新款女装宽松潮V领破洞镂空字母印花短袖T恤', 56.00, 39.00, 'http://s3.mogucdn.com/mlcdn/c45406/180514_1429jg0febkbdfk1ab3c8clah84cb_640x960.jpg_560x999.jpg', 1, '2021-12-18 14:27:29', '2021-12-18 14:27:29', 10);
INSERT INTO `product` VALUES (104, '2018夏装新款修身显瘦性感拼色针织女短款韩版休闲打底衫上衣吊带背心', '2018夏装新款修身显瘦性感拼色针织女短款韩版休闲打底衫上衣吊带背心', 43.00, 30.00, 'http://s3.mogucdn.com/mlcdn/c45406/180605_25ah46f6e61dk43g22i3cf6dckcf6_640x960.jpg_560x999.jpg', 1, '2021-12-18 14:27:29', '2021-12-18 14:27:29', 9);
INSERT INTO `product` VALUES (105, '2018秋季新品韩范休闲宽松百搭牛仔外套气质显瘦中长款吊带连衣裙套装', '2018秋季新品韩范休闲宽松百搭牛仔外套气质显瘦中长款吊带连衣裙套装', 84.00, 59.00, 'http://s3.mogucdn.com/mlcdn/c45406/180901_60e7c737k66c4i5f7bj50l38c91ie_640x960.jpg_560x999.jpg', 1, '2021-12-18 14:27:29', '2021-12-18 14:27:29', 6);
INSERT INTO `product` VALUES (106, '时尚套装两件套网红同款2018秋装女套装新款显瘦中长款字母印花宽松套头卫衣无敌修身打底长裤', '时尚套装两件套网红同款2018秋装女套装新款显瘦中长款字母印花宽松套头卫衣无敌修身打底长裤', 119.00, 84.00, 'http://s11.mogucdn.com/mlcdn/c45406/180914_1lj3hk5hek8266fdf77elg1h78fg8_640x960.jpg_560x999.jpg', 1, '2021-12-18 14:27:29', '2021-12-18 14:27:29', 9);
INSERT INTO `product` VALUES (107, '2018夏季新款紫色百搭款套头宽松学生T恤女上衣潮4色', '2018夏季新款紫色百搭款套头宽松学生T恤女上衣潮4色', 70.00, 49.00, 'http://s11.mogucdn.com/mlcdn/c45406/180611_8ahf5d6jh7gb9bjfll1f5bi33gil1_640x960.jpg_560x999.jpg', 1, '2021-12-18 14:27:29', '2021-12-18 14:27:29', 7);
INSERT INTO `product` VALUES (108, '2件50元qlz夏季2018情侣装新款宽松女韩版潮学生百搭网红同款短袖T恤上衣小哥哥印花', '2件50元qlz夏季2018情侣装新款宽松女韩版潮学生百搭网红同款短袖T恤上衣小哥哥印花', 40.00, 28.00, 'http://s11.mogucdn.com/mlcdn/17f85e/180607_835hbfgcffaijjil95428cii1k9ef_640x960.jpg_560x999.jpg', 1, '2021-12-18 14:27:29', '2021-12-18 14:27:29', 7);
INSERT INTO `product` VALUES (109, '高领黑白条纹长袖t恤女2018春秋新款韩版宽松百搭学生内搭打底衫', '高领黑白条纹长袖t恤女2018春秋新款韩版宽松百搭学生内搭打底衫', 43.00, 30.00, 'http://s3.mogucdn.com/mlcdn/c45406/180126_39bjhej66kb2l48554kk0ld4d2fdc_640x960.jpg_560x999.jpg', 1, '2021-12-18 14:27:29', '2021-12-18 14:27:29', NULL);
INSERT INTO `product` VALUES (110, '2018秋冬新款网红性感欧根纱蝴蝶领结上衣+高腰显瘦半身皮裙2件套套装', '2018秋冬新款网红性感欧根纱蝴蝶领结上衣+高腰显瘦半身皮裙2件套套装', 142.00, 99.00, 'http://s3.mogucdn.com/mlcdn/55cf19/180827_1l1278e9l144ih07kjdbk58ea0046_640x960.jpg_560x999.jpg', 1, '2021-12-18 14:27:29', '2021-12-18 14:27:29', NULL);
INSERT INTO `product` VALUES (111, '2018秋新款韩版时尚简约系带显瘦条纹系带西服套装女', '2018秋新款韩版时尚简约系带显瘦条纹系带西服套装女', 154.00, 108.00, 'http://s11.mogucdn.com/mlcdn/c45406/180815_7ff4fbk769cc2d1c2l494ie7j5jke_640x908.jpg_560x999.jpg', 1, '2021-12-18 14:27:29', '2021-12-18 14:27:29', 5);
INSERT INTO `product` VALUES (112, '2018夏季新款纯色体恤韩版白色短袖T恤女百搭学生黑色宽松圆领上衣显瘦打底衫', '2018夏季新款纯色体恤韩版白色短袖T恤女百搭学生黑色宽松圆领上衣显瘦打底衫', 56.00, 39.00, 'http://s3.mogucdn.com/p2/170310/89187459_176ced5dd1lk16ggeadh7j6i3hg8g_640x960.jpg_560x999.jpg', 1, '2021-12-18 14:27:29', '2021-12-18 14:27:29', 5);
INSERT INTO `product` VALUES (113, '2018秋季新款韩范清新套装宽松圆领可爱学生条纹上衣配复古高腰直筒裤子破洞牛仔裤时尚两件套', '2018秋季新款韩范清新套装宽松圆领可爱学生条纹上衣配复古高腰直筒裤子破洞牛仔裤时尚两件套', 79.00, 55.00, 'http://s11.mogucdn.com/mlcdn/c45406/180901_024lb916jjb699j4dg56048e51jj6_640x960.jpg_560x999.jpg', 1, '2021-12-18 14:27:29', '2021-12-18 14:27:29', 6);
INSERT INTO `product` VALUES (114, '宽松白色短袖T恤女韩版半袖上衣印花2018夏季女装新款班服ins时尚百搭学生衣服大码体恤', '宽松白色短袖T恤女韩版半袖上衣印花2018夏季女装新款班服ins时尚百搭学生衣服大码体恤', 43.00, 30.00, 'http://s3.mogucdn.com/mlcdn/c45406/180605_445c0g87j0k130ja2di46cj9403h7_800x1200.jpg_560x999.jpg', 1, '2021-12-18 14:27:29', '2021-12-18 14:27:29', NULL);
INSERT INTO `product` VALUES (115, '【两件59元】【 降价啦！】2018夏装新款高品质纯棉t恤女短袖白色圆领宽松学生半袖上衣', '【两件59元】【 降价啦！】2018夏装新款高品质纯棉t恤女短袖白色圆领宽松学生半袖上衣', 56.00, 39.00, 'http://s11.mogucdn.com/mlcdn/c45406/180302_58kc4dk5820fj4ihjdh3e4k2b3h4e_640x960.jpg_560x999.jpg', 1, '2021-12-18 14:27:29', '2021-12-18 14:27:29', 5);
INSERT INTO `product` VALUES (116, '2018夏装新款韩范t恤女短袖宽松百搭韩版学生半袖ins超火的上衣体侐潮', '2018夏装新款韩范t恤女短袖宽松百搭韩版学生半袖ins超火的上衣体侐潮', 50.00, 50.00, 'http://s11.mogucdn.com/mlcdn/55cf19/180620_81idi257gjk9kl4i61bel5kak5362_640x960.jpg_560x999.jpg', 1, '2021-12-18 14:27:29', '2021-12-18 14:27:29', 8);
INSERT INTO `product` VALUES (117, '2018春夏装新款上衣圆领休闲百搭韩版打底衫纯色白色棉t恤女短袖宽松学生半袖tee情侣男', '2018春夏装新款上衣圆领休闲百搭韩版打底衫纯色白色棉t恤女短袖宽松学生半袖tee情侣男', 57.00, 40.00, 'http://s11.mogucdn.com/mlcdn/c45406/180122_5dh2dl7862136dkcfh0haaalc3517_640x960.jpg_560x999.jpg', 1, '2021-12-18 14:27:29', '2021-12-18 14:27:29', 9);
INSERT INTO `product` VALUES (118, '秋季新款套装两件套秋装2018新款韩版chic泡泡袖衬衫上衣+高腰显瘦牛仔裤学院风时尚套装', '秋季新款套装两件套秋装2018新款韩版chic泡泡袖衬衫上衣+高腰显瘦牛仔裤学院风时尚套装', 69.00, 48.00, 'http://s3.mogucdn.com/mlcdn/c45406/180910_72kcibhh4i275l73ik681kbed19aj_640x960.jpg_560x999.jpg', 1, '2021-12-18 14:27:29', '2021-12-18 14:27:29', 9);
INSERT INTO `product` VALUES (119, '纯棉白色t恤女夏短袖修身短款半袖2018新款夏装紧身黑色体恤上衣长袖秋冬', '纯棉白色t恤女夏短袖修身短款半袖2018新款夏装紧身黑色体恤上衣长袖秋冬', 57.00, 40.00, 'http://s3.mogucdn.com/mlcdn/c45406/180925_17cd358662ffc9jhah6bf6bl99c75_640x960.jpg_560x999.jpg', 1, '2021-12-18 14:27:29', '2021-12-18 14:27:29', 8);
INSERT INTO `product` VALUES (120, '珊珊2018秋装新款韩版百搭修身显瘦气质甜美荷叶边下摆初恋女裙蕾丝拼接长袖针织连衣裙', '珊珊2018秋装新款韩版百搭修身显瘦气质甜美荷叶边下摆初恋女裙蕾丝拼接长袖针织连衣裙', 155.00, 79.00, 'http://s11.mogucdn.com/mlcdn/c45406/180906_09ce0e8a14l71k3ll34dah14j80kd_640x960.jpg_560x999.jpg', 1, '2021-12-18 14:27:29', '2021-12-18 14:27:29', 5);
INSERT INTO `product` VALUES (121, '2018夏装新款高品质短袖t恤女纯棉圆领宽松显瘦韩版学生女装', '2018夏装新款高品质短袖t恤女纯棉圆领宽松显瘦韩版学生女装', 56.00, 39.00, 'http://s11.mogucdn.com/mlcdn/c45406/180305_2ljefab431fgach9g3b1gl72li11f_640x960.jpg_560x999.jpg', 1, '2021-12-18 14:27:29', '2021-12-18 14:27:29', 6);
INSERT INTO `product` VALUES (122, '2件50元班服夏季t恤女短袖宽松学生情侣装夏装2018新款韩版ulzzang百搭衣服潮宽松', '2件50元班服夏季t恤女短袖宽松学生情侣装夏装2018新款韩版ulzzang百搭衣服潮宽松', 40.00, 28.00, 'http://s11.mogucdn.com/mlcdn/c45406/180416_359hjeljbc1djcf29db75b11j401c_640x960.jpg_560x999.jpg', 1, '2021-12-18 14:27:29', '2021-12-18 14:27:29', NULL);
INSERT INTO `product` VALUES (123, '中长款长袖连衣裙秋装新款2018韩版休闲胖mm大码女装裙子女学生宽松松垮垮中长款卫衣裙外套', '中长款长袖连衣裙秋装新款2018韩版休闲胖mm大码女装裙子女学生宽松松垮垮中长款卫衣裙外套', 168.00, 54.00, 'http://s3.mogucdn.com/mlcdn/c45406/180916_4di1ek7k3kha3klk02185678b025d_640x960.jpg_560x999.jpg', 1, '2021-12-18 14:27:29', '2021-12-18 14:27:29', 6);
INSERT INTO `product` VALUES (124, '2018新款早春款韩版百搭宽松体恤刺绣字母圆领短袖T恤女学生上衣服洋气小衫', '2018新款早春款韩版百搭宽松体恤刺绣字母圆领短袖T恤女学生上衣服洋气小衫', 57.00, 40.00, 'http://s3.mogucdn.com/mlcdn/c45406/180416_4f73g9612ge2jja058g0gkhia406f_640x960.jpg_560x999.jpg', 1, '2021-12-18 14:27:29', '2021-12-18 14:27:29', NULL);
INSERT INTO `product` VALUES (125, '实拍韩版2018秋冬新款学院风百搭高腰显瘦PU皮裙伞裙系带防走光显瘦半身裙短裙', '实拍韩版2018秋冬新款学院风百搭高腰显瘦PU皮裙伞裙系带防走光显瘦半身裙短裙', 169.00, 59.00, 'http://s11.mogucdn.com/mlcdn/c45406/180916_196h301k3fje7762dkhi5l6l99099_640x982.jpg_560x999.jpg', 1, '2021-12-18 14:27:29', '2021-12-18 14:27:29', 10);
INSERT INTO `product` VALUES (126, '春秋2018ins超火的新款韩版简约百搭宽松字母印花长袖T恤学生休闲体恤显瘦上衣潮', '春秋2018ins超火的新款韩版简约百搭宽松字母印花长袖T恤学生休闲体恤显瘦上衣潮', 40.00, 40.00, 'http://s11.mogucdn.com/mlcdn/55cf19/180823_65bk4i19ff244if74226eeb4lchdc_640x960.jpg_560x999.jpg', 1, '2021-12-18 14:27:29', '2021-12-18 14:27:29', 8);
INSERT INTO `product` VALUES (127, '明星同款2018秋季新款韩版女装高腰裙子针织毛线百搭秋冬中长款显瘦A字半身裙', '明星同款2018秋季新款韩版女装高腰裙子针织毛线百搭秋冬中长款显瘦A字半身裙', 169.00, 69.00, 'http://s11.mogucdn.com/mlcdn/c45406/180916_7j0dh9d7a1dlac84bf3jebj39fil0_640x812.jpg_560x999.jpg', 1, '2021-12-18 14:27:29', '2021-12-18 14:27:29', 7);
INSERT INTO `product` VALUES (128, '2018夏装新款韩范v领交叉粉色短袖T恤女装纯色半截袖小心机上衣', '2018夏装新款韩范v领交叉粉色短袖T恤女装纯色半截袖小心机上衣', 57.00, 40.00, 'http://s3.mogucdn.com/mlcdn/c45406/180620_19fk93bjc8adfg9h7ak978409kei9_640x960.jpg_560x999.jpg', 1, '2021-12-18 14:27:29', '2021-12-18 14:27:29', 5);
INSERT INTO `product` VALUES (129, '2018新款时尚百搭黑色宽松机车皮夹克+网纱半身裙套装两件套', '2018新款时尚百搭黑色宽松机车皮夹克+网纱半身裙套装两件套', 226.00, 158.00, 'http://s3.mogucdn.com/mlcdn/55cf19/180917_7e2fdc2d8131698jkg69c9586lkel_640x960.jpg_560x999.jpg', 1, '2021-12-18 14:27:29', '2021-12-18 14:27:29', 8);
INSERT INTO `product` VALUES (130, '秋装女卫衣套装新款2018韩版印花连帽卫衣上衣+显瘦高腰网纱半身裙学生裙子时尚套装两件套', '秋装女卫衣套装新款2018韩版印花连帽卫衣上衣+显瘦高腰网纱半身裙学生裙子时尚套装两件套', 70.00, 49.00, 'http://s11.mogucdn.com/mlcdn/c45406/180913_00b8bg3cg308c9jhcakhj0c7fhbih_640x960.jpg_560x999.jpg', 1, '2021-12-18 14:27:29', '2021-12-18 14:27:29', 10);
INSERT INTO `product` VALUES (131, '2018新款女装秋装简约衬衫女长袖雪纺上衣百搭纯色韩范打底衬衣女', '2018新款女装秋装简约衬衫女长袖雪纺上衣百搭纯色韩范打底衬衣女', 80.00, 56.00, 'http://s3.mogucdn.com/mlcdn/c45406/180411_7ei8d3aabhkkg5b6312gh1ckak8f1_640x960.jpg_560x999.jpg', 1, '2021-12-18 14:27:29', '2021-12-18 14:27:29', 7);
INSERT INTO `product` VALUES (132, '【时尚套装】2018秋款新款牛仔背带裙女夏吊带连衣裙搭配T恤新款小清新两件套女', '【时尚套装】2018秋款新款牛仔背带裙女夏吊带连衣裙搭配T恤新款小清新两件套女', 99.00, 69.00, 'http://s3.mogucdn.com/mlcdn/c45406/180821_044abj5e7h2icfgijb053661lle8f_800x800.jpg_560x999.jpg', 1, '2021-12-18 14:27:29', '2021-12-18 14:27:29', 10);
INSERT INTO `product` VALUES (133, 'chic港味秋装女套装新款2018韩版格子西装外套+显瘦高腰破洞小脚裤学院风时尚套装两件套', 'chic港味秋装女套装新款2018韩版格子西装外套+显瘦高腰破洞小脚裤学院风时尚套装两件套', 79.00, 55.00, 'http://s11.mogucdn.com/mlcdn/c45406/180914_4k0k14g1608gc04k3jh1c6jac47fi_640x960.jpg_560x999.jpg', 1, '2021-12-18 14:27:29', '2021-12-18 14:27:29', 10);
INSERT INTO `product` VALUES (134, '杨幂明星同款2018新款白色ins超火短袖t恤女字母宽松纯棉百搭上衣', '杨幂明星同款2018新款白色ins超火短袖t恤女字母宽松纯棉百搭上衣', 54.00, 37.00, 'http://s11.mogucdn.com/mlcdn/c45406/180624_6jb1g4kg6i1ab4i4g0echaia49i87_640x960.png_560x999.jpg', 1, '2021-12-18 14:27:29', '2021-12-18 14:27:29', 9);
INSERT INTO `product` VALUES (135, '送运费险短袖t恤女2018夏季新款女装韩版时尚气质百搭ulzzang学生百搭小心机纯色上衣', '送运费险短袖t恤女2018夏季新款女装韩版时尚气质百搭ulzzang学生百搭小心机纯色上衣', 57.00, 40.00, 'http://s11.mogucdn.com/mlcdn/c45406/180621_00e5i2711h0de8lhe4568kkie9d90_640x960.jpg_560x999.jpg', 1, '2021-12-18 14:27:29', '2021-12-18 14:27:29', NULL);
INSERT INTO `product` VALUES (136, '雪纺阔腿裤女春夏高腰黑色韩版2018新款九分宽松显瘦度假沙滩裤裙', '雪纺阔腿裤女春夏高腰黑色韩版2018新款九分宽松显瘦度假沙滩裤裙', 70.00, 49.00, 'http://s3.mogucdn.com/mlcdn/17f85e/180529_3bfb1bf04i91k9iaaj78ck4k4k814_640x960.jpg_560x999.jpg', 1, '2021-12-18 14:27:29', '2021-12-18 14:27:29', 6);
INSERT INTO `product` VALUES (137, '网红同款实拍秋季女装2018新款女初恋复古中长款针织连衣裙半身裙时尚套装两件套', '网红同款实拍秋季女装2018新款女初恋复古中长款针织连衣裙半身裙时尚套装两件套', 369.00, 119.00, 'http://s11.mogucdn.com/mlcdn/c45406/180917_24666f4kgi486191382ikh2lhc8cg_640x862.jpg_560x999.jpg', 1, '2021-12-18 14:27:29', '2021-12-18 14:27:29', 5);
INSERT INTO `product` VALUES (138, '2018秋冬新款ins超火针织时尚两件套小香风套装女', '2018秋冬新款ins超火针织时尚两件套小香风套装女', 154.00, 108.00, 'http://s3.mogucdn.com/mlcdn/c45406/180815_81dj3id2i70kfeh4eekd94k9ij0k4_640x913.jpg_560x999.jpg', 1, '2021-12-18 14:27:29', '2021-12-18 14:27:29', NULL);
INSERT INTO `product` VALUES (139, '2018春秋季新款韩版原宿风闺蜜装圆领套头短袖t恤女中长款纯色百搭上衣宽松大码学生半袖体恤', '2018春秋季新款韩版原宿风闺蜜装圆领套头短袖t恤女中长款纯色百搭上衣宽松大码学生半袖体恤', 70.00, 49.00, 'http://s3.mogucdn.com/mlcdn/c45406/180514_104a5k2f09808h371j8b3h299e870_640x960.jpg_560x999.jpg', 1, '2021-12-18 14:27:29', '2021-12-18 14:27:29', 8);
INSERT INTO `product` VALUES (140, '2018春秋季新款女装韩版宽松短袖t恤女chic半袖打底条纹体恤上衣', '2018春秋季新款女装韩版宽松短袖t恤女chic半袖打底条纹体恤上衣', 50.00, 35.00, 'http://s11.mogucdn.com/mlcdn/c45406/180512_3e1962h3haa801048j1gi21024031_640x960.jpg_560x999.jpg', 1, '2021-12-18 14:27:29', '2021-12-18 14:27:29', 7);
INSERT INTO `product` VALUES (141, '长袖/短袖T恤女2018新款棉质学生宽松韩版夏季可爱卡通猫咪印花纯色百搭打底衫上衣女潮', '长袖/短袖T恤女2018新款棉质学生宽松韩版夏季可爱卡通猫咪印花纯色百搭打底衫上衣女潮', 52.00, 52.00, 'http://s11.mogucdn.com/mlcdn/c45406/180423_54e410ebffkj73cah5e513584b5fb_800x800.jpg_560x999.jpg', 1, '2021-12-18 14:27:29', '2021-12-18 14:27:29', 6);
INSERT INTO `product` VALUES (142, '哈伦裤女秋季2018新款韩版学生显瘦雪纺薄款休闲裤女宽松黑色西装西裤九分裤夏小脚萝卜烟管裤', '哈伦裤女秋季2018新款韩版学生显瘦雪纺薄款休闲裤女宽松黑色西装西裤九分裤夏小脚萝卜烟管裤', 69.00, 48.00, 'http://s11.mogucdn.com/mlcdn/17f85e/180902_2cefh0g12jk4i71bg270843d39l8j_640x960.jpg_560x999.jpg', 1, '2021-12-18 14:27:29', '2021-12-18 14:27:29', 9);
INSERT INTO `product` VALUES (143, '2018春秋季韩版新款条纹外穿内搭上衣打底吊带百搭无袖T恤针织背心女', '2018春秋季韩版新款条纹外穿内搭上衣打底吊带百搭无袖T恤针织背心女', 41.00, 29.00, 'http://s11.mogucdn.com/mlcdn/c45406/180521_5ijdcl888016gfaag2id2e0g8l19j_640x960.jpg_560x999.jpg', 1, '2021-12-18 14:27:29', '2021-12-18 14:27:29', 8);
INSERT INTO `product` VALUES (144, '秋装女2018新款早秋女装裙子韩版针织连衣裙+衬衫上衣时尚套装', '秋装女2018新款早秋女装裙子韩版针织连衣裙+衬衫上衣时尚套装', 127.00, 89.00, 'http://s3.mogucdn.com/mlcdn/c45406/180828_550k23i82cbibh32602fl43jc9aid_800x1200.jpg_560x999.jpg', 1, '2021-12-18 14:27:29', '2021-12-18 14:27:29', 5);
INSERT INTO `product` VALUES (145, '雪纺阔腿裤女夏2018新款裤子黑色韩版休闲裤女七分宽松直筒高腰秋冬秋季九分宽腿裤', '雪纺阔腿裤女夏2018新款裤子黑色韩版休闲裤女七分宽松直筒高腰秋冬秋季九分宽腿裤', 69.00, 48.00, 'http://s3.mogucdn.com/mlcdn/17f85e/180902_1gd2jld5b1g6dfl57da4jdj07alac_640x960.jpg_560x999.jpg', 1, '2021-12-18 14:27:29', '2021-12-18 14:27:29', 7);
INSERT INTO `product` VALUES (146, '套装女春秋2018新款时尚复古气质个性连帽卫衣两件套', '套装女春秋2018新款时尚复古气质个性连帽卫衣两件套', 211.00, 148.00, 'http://s3.mogucdn.com/mlcdn/c45406/180825_4figj590flej05g556d6ll8ka09a7_640x902.jpg_560x999.jpg', 1, '2021-12-18 14:27:29', '2021-12-18 14:27:29', NULL);
INSERT INTO `product` VALUES (147, '时尚套装两件套2018韩版网红社会宽松连帽卫衣+高腰显瘦开叉半身裙学院风休闲秋装女套装新款', '时尚套装两件套2018韩版网红社会宽松连帽卫衣+高腰显瘦开叉半身裙学院风休闲秋装女套装新款', 199.00, 98.00, 'http://s3.mogucdn.com/mlcdn/c45406/180914_3aabiea9jgkj2a7hlgfie4011bljj_640x960.jpg_560x999.jpg', 1, '2021-12-18 14:27:29', '2021-12-18 14:27:29', 10);
INSERT INTO `product` VALUES (148, '被子', NULL, 14.00, 14.00, NULL, 0, '2022-03-19 23:19:23', '2022-03-19 23:19:23', NULL);

-- ----------------------------
-- Table structure for product_category
-- ----------------------------
DROP TABLE IF EXISTS `product_category`;
CREATE TABLE `product_category`  (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `create_time` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `last_modify_time` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 15 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of product_category
-- ----------------------------
INSERT INTO `product_category` VALUES (5, '裤子', '2021-12-18 14:15:08', '2021-12-18 14:15:08');
INSERT INTO `product_category` VALUES (6, '女装', '2021-12-18 14:15:08', '2021-12-18 14:15:08');
INSERT INTO `product_category` VALUES (7, '厨具', '2021-12-18 14:15:08', '2021-12-18 14:15:08');
INSERT INTO `product_category` VALUES (8, '上衣', '2021-12-18 14:15:08', '2021-12-18 14:15:08');
INSERT INTO `product_category` VALUES (9, '床上用品', '2021-12-18 14:15:08', '2021-12-18 14:15:08');
INSERT INTO `product_category` VALUES (10, '家具', '2021-12-18 14:15:08', '2021-12-18 14:15:08');
INSERT INTO `product_category` VALUES (13, '鞋子', '2021-12-19 16:10:53', '2021-12-19 16:10:53');
INSERT INTO `product_category` VALUES (14, '男装', '2022-03-19 23:19:55', '2022-03-19 23:19:55');

-- ----------------------------
-- Table structure for product_collection
-- ----------------------------
DROP TABLE IF EXISTS `product_collection`;
CREATE TABLE `product_collection`  (
  `user_id` varchar(10) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `product_id` int(10) UNSIGNED NOT NULL,
  `time` datetime(0) NULL DEFAULT NULL,
  PRIMARY KEY (`user_id`, `product_id`) USING BTREE,
  INDEX `coll_prod_ref`(`product_id`) USING BTREE,
  CONSTRAINT `coll_prod_ref` FOREIGN KEY (`product_id`) REFERENCES `product` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `coll_user_ref` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for role
-- ----------------------------
DROP TABLE IF EXISTS `role`;
CREATE TABLE `role`  (
  `symbol` int(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '唯一标记',
  `name` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '角色名称',
  `introduction` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '角色简介',
  `permissions` varchar(800) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '角色拥有的权限',
  `create_time` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `last_modify_time` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`symbol`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 10 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of role
-- ----------------------------
INSERT INTO `role` VALUES (2, '超级管理员', '系统管理员', '5,2,201,202,203,204,501,502,503,20101,20102,20103,20104,20201,20202,20203,20204,20303,20304,20401,20402,20403,20404,50101,50102,50103,50104,50105', '2021-12-16 17:00:45', '2022-05-30 16:17:39');
INSERT INTO `role` VALUES (3, 'HR', '人力资源管理', '1,2,3,4,20101,201,5', '2021-12-17 17:41:12', '2022-05-30 16:16:10');
INSERT INTO `role` VALUES (4, 'Department leader', '部门领导', '1,102,2,201,20101,20102,20103,20104,202,20201,20202,20203,20204,203,20303,20304,204,20401,20402,20403,20404', '2021-12-17 23:21:23', '2022-06-11 18:00:00');
INSERT INTO `role` VALUES (5, 'worker', '员工', '50101,50102,50103,50104,502,503,5,501', '2021-12-19 16:08:11', '2022-06-12 23:15:30');
INSERT INTO `role` VALUES (9, 'test', 'teste', '5,501,50101,50102,50103,50104,50105,502,503', '2022-06-11 18:06:59', '2022-06-11 18:06:59');

-- ----------------------------
-- Table structure for schedule
-- ----------------------------
DROP TABLE IF EXISTS `schedule`;
CREATE TABLE `schedule`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `reason` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `start` datetime(0) NULL,
  `end` datetime(0) NULL,
  `status` int(11) NOT NULL,
  `type` int(11) NOT NULL,
  `create_time` datetime(0) NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime(0) NULL DEFAULT CURRENT_TIMESTAMP,
  `user_id` varchar(10) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `schedule_id_uindex`(`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 37 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of schedule
-- ----------------------------
INSERT INTO `schedule` VALUES (16, 'home', '2022-04-28 08:00:00', '2022-04-30 08:00:00', 1, 0, '2022-04-28 11:27:58', '2022-04-28 11:27:58', 'root');
INSERT INTO `schedule` VALUES (17, 'm,ai', '2022-04-05 08:00:00', '2022-04-22 08:00:00', 2, 1, '2022-04-29 09:15:11', '2022-04-29 09:15:11', 'xs');
INSERT INTO `schedule` VALUES (19, '五一放假', '2022-05-01 08:00:00', '2022-05-04 08:00:00', 0, 0, '2022-04-30 18:46:51', '2022-04-30 18:46:51', 'xsxs');
INSERT INTO `schedule` VALUES (20, 'go home', '2022-04-28 00:00:00', '2022-04-30 00:00:00', 1, 0, '2022-05-26 23:34:14', '2022-05-26 23:34:14', 'root');
INSERT INTO `schedule` VALUES (21, 'go home', '2022-04-26 00:00:00', '2022-05-11 00:00:00', 1, 0, '2022-05-30 15:38:46', '2022-05-30 15:38:46', 'test');
INSERT INTO `schedule` VALUES (24, 'go home', '2022-04-28 00:00:00', '2022-04-30 00:00:00', 1, 1, '2022-05-31 10:43:13', '2022-05-31 10:43:13', 'root');
INSERT INTO `schedule` VALUES (36, 'fdfd', '2022-06-01 00:00:00', '2022-06-15 00:00:00', 1, 1, '2022-06-11 19:55:35', '2022-06-11 19:55:35', 'test');

-- ----------------------------
-- Table structure for user
-- ----------------------------
DROP TABLE IF EXISTS `user`;
CREATE TABLE `user`  (
  `id` varchar(10) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `url` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `user_name` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `password` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `department_id` int(10) UNSIGNED NULL DEFAULT NULL,
  `status` tinyint(4) NOT NULL DEFAULT 1,
  `role_id` int(10) UNSIGNED NULL DEFAULT NULL,
  `real_name` varchar(10) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `cellphone` varchar(11) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `sex` int(1) NULL DEFAULT 1,
  `introduction` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `create_time` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `last_modify_time` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `user_role_ref`(`role_id`) USING BTREE,
  INDEX `user_dep_ref`(`department_id`) USING BTREE,
  CONSTRAINT `user_dep_ref` FOREIGN KEY (`department_id`) REFERENCES `department` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `user_role_ref` FOREIGN KEY (`role_id`) REFERENCES `role` (`symbol`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of user
-- ----------------------------
INSERT INTO `user` VALUES ('LIlyfy', NULL, 'lily', '123456', NULL, 0, 2, 'liuli', '15894785687', 1, NULL, '2021-12-16 22:34:12', '2021-12-18 22:51:37');
INSERT INTO `user` VALUES ('root', NULL, '超级管理员', '123456', 1002, 1, 2, '超级管理元', '13856754532', 1, NULL, '2021-12-15 15:33:44', '2021-12-18 22:53:22');
INSERT INTO `user` VALUES ('test', NULL, 'test', '123456', 1001, 1, 5, 'test', '125486585', 1, NULL, '2021-12-23 09:57:48', '2021-12-23 09:57:48');
INSERT INTO `user` VALUES ('xs', '', 'coderxs', '723329', 1003, 1, 9, 'xs', '17548567849', 1, NULL, '2021-12-14 14:23:23', '2022-06-11 18:17:32');
INSERT INTO `user` VALUES ('xsxs', NULL, 'xsxs', 'xsxsxss', NULL, 1, NULL, 'xsxs', 'xsxsxsx', 1, NULL, '2021-12-18 22:43:36', '2021-12-18 22:43:36');
INSERT INTO `user` VALUES ('yushusixs', NULL, 'yushus', 'xddfgdfdf', NULL, 1, NULL, 'fdfdfdf', '488484', 1, NULL, '2021-12-18 22:45:08', '2021-12-18 22:48:10');
INSERT INTO `user` VALUES ('zbd', '/', '谁的包庇', '723329', 1001, 1, 3, 'zbd', '18355895320', 1, NULL, '2021-12-14 00:00:00', '2021-12-16 22:13:17');

-- ----------------------------
-- Table structure for work_check
-- ----------------------------
DROP TABLE IF EXISTS `work_check`;
CREATE TABLE `work_check`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `date` date NOT NULL,
  `type` int(11) NOT NULL,
  `start` time(0) NOT NULL,
  `end` time(0) NULL DEFAULT NULL,
  `start_check` time(0) NULL DEFAULT NULL,
  `end_check` time(0) NULL DEFAULT NULL,
  `work_time` decimal(10, 0) NULL DEFAULT NULL,
  `remark` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `create_time` datetime(0) NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime(0) NULL DEFAULT CURRENT_TIMESTAMP,
  `user_id` varchar(10) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `work_check_id_uindex`(`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 74 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of work_check
-- ----------------------------
INSERT INTO `work_check` VALUES (27, '2022-04-28', 0, '23:56:00', '18:26:00', '11:27:23', '15:15:13', 4, '0', '2022-04-28 11:27:23', '2022-04-28 11:27:23', 'root');
INSERT INTO `work_check` VALUES (29, '2022-04-30', 0, '09:30:00', '18:30:00', '18:29:26', '18:36:01', 0, '1', '2022-04-30 18:29:26', '2022-04-30 18:29:26', 'root');
INSERT INTO `work_check` VALUES (72, '2022-06-12', 1, '22:15:27', '22:16:27', '23:08:51', '23:18:14', 1, '1', '2022-06-12 23:08:51', '2022-06-12 23:08:51', 'root');
INSERT INTO `work_check` VALUES (73, '2022-06-13', 0, '08:30:00', '17:30:00', '09:06:04', '00:00:00', 0, '1', '2022-06-13 09:06:04', '2022-06-13 09:06:04', 'root');

-- ----------------------------
-- View structure for department_with_user
-- ----------------------------
DROP VIEW IF EXISTS `department_with_user`;
CREATE ALGORITHM = UNDEFINED DEFINER = `root`@`%` SQL SECURITY DEFINER VIEW `department_with_user` AS select `department`.`id` AS `id`,`department`.`name` AS `name`,`department`.`super_id` AS `super_id`,`department`.`create_time` AS `create_time`,`department`.`last_modify_time` AS `last_modify_time`,`user`.`id` AS `leaderId`,`user`.`user_name` AS `leader_name` from (`department` join `user` on(((`user`.`department_id` = `department`.`id`) and (`department`.`leader` = `user`.`id`))));

-- ----------------------------
-- View structure for product_with_category
-- ----------------------------
DROP VIEW IF EXISTS `product_with_category`;
CREATE ALGORITHM = UNDEFINED DEFINER = `root`@`%` SQL SECURITY DEFINER VIEW `product_with_category` AS select `product`.`id` AS `id`,`product`.`name` AS `name`,`product`.`introduction` AS `introduction`,`product`.`origin_price` AS `origin_price`,`product`.`current_price` AS `current_price`,`product`.`url` AS `url`,`product`.`status` AS `status`,`product`.`create_time` AS `create_time`,`product`.`last_modify_time` AS `last_modify_time`,`product`.`category` AS `category`,`product_category`.`name` AS `category_name` from (`product` join `product_category` on((`product`.`category` = `product_category`.`id`)));

-- ----------------------------
-- View structure for user_with_role
-- ----------------------------
DROP VIEW IF EXISTS `user_with_role`;
CREATE ALGORITHM = UNDEFINED DEFINER = `root`@`%` SQL SECURITY DEFINER VIEW `user_with_role` AS select `user`.`id` AS `id`,`user`.`user_name` AS `user_name`,`user`.`cellphone` AS `cellphone`,`user`.`real_name` AS `real_name`,`user`.`status` AS `status`,`role`.`name` AS `role_name`,`user`.`url` AS `url`,`user`.`create_time` AS `create_time`,`user`.`last_modify_time` AS `last_modify_time`,`department`.`name` AS `department_name` from ((`user` join `role` on((`user`.`role_id` = `role`.`symbol`))) join `department` on(((`department`.`leader` = `user`.`id`) and (`user`.`department_id` = `department`.`id`))));

-- ----------------------------
-- Procedure structure for bind_all_permissions
-- ----------------------------
DROP PROCEDURE IF EXISTS `bind_all_permissions`;
delimiter ;;
CREATE DEFINER=`root`@`%` PROCEDURE `bind_all_permissions`(IN `roleId` int(10))
BEGIN
  # 给1个角色绑定所有权限
  declare current int(10);
	declare sum_str varchar(300) default '';
  declare done tinyint default 0;
	declare c cursor for select id from permission;
  declare continue handler for NOT FOUND set done = 1;

	open c;
  task: loop
		fetch c into current;
		if (done) then
			leave task;
		end if;
		set sum_str = concat(sum_str, current, ',');
	end loop;
	close c;
	set sum_str = substr(sum_str, 1,length(sum_str) - 1);
	select sum_str;
	update role set permissions = sum_str where symbol = roleId;
END
;;
delimiter ;

-- ----------------------------
-- Procedure structure for bind_query_permissions
-- ----------------------------
DROP PROCEDURE IF EXISTS `bind_query_permissions`;
delimiter ;;
CREATE DEFINER=`root`@`%` PROCEDURE `bind_query_permissions`(IN `roleId` int(10))
BEGIN
	# 
  declare sum_str varchar(300) default "1,2,3,4,101,102,";
  declare done tinyint default 0;
	declare current int(10);
	declare c cursor for select id from permission where button="query";
  declare continue handler for NOT FOUND set done = 1;

	open c;
  task: loop
		fetch c into current;
		if (done) then
			leave task;
		end if;
		set sum_str = concat(sum_str, current, ',');
	end loop;
	close c;
	set sum_str = substr(sum_str, 1,length(sum_str) - 1);
	select sum_str;
	update role set permissions = sum_str where symbol = roleId;
END
;;
delimiter ;

-- ----------------------------
-- Function structure for error
-- ----------------------------
DROP FUNCTION IF EXISTS `error`;
delimiter ;;
CREATE DEFINER=`root`@`%` FUNCTION `error`() RETURNS int(11)
BEGIN
  # 总是错的
  insert into error_tool value(null);
	RETURN 0;
END
;;
delimiter ;

-- ----------------------------
-- Procedure structure for test
-- ----------------------------
DROP PROCEDURE IF EXISTS `test`;
delimiter ;;
CREATE DEFINER=`root`@`%` PROCEDURE `test`()
BEGIN
  declare i, max int(3) default 1;
  declare len1, len2 int(3) default 0;
  declare temp_permission varchar(100) default '1';
  declare flag int(3) default 0;
  declare str varchar(100) default "1,2,3,4,101,102,201,202,203,205";
  set len1 = length(str);
  # 将 , 换为 空字符
  set len2 = length(replace(str, ',', ''));
  set max = len1 - len2 + 1;
  task: loop
    set temp_permission = substring_index(substring_index(str, ',', i),',',-1);
    select count(id) into flag from permission where id = temp_permission;
		select * from permission where id = temp_permission;
    if (flag != 1) then
      insert into error_tool value(null);
      leave task;
    end if;
    set i = i+1;
    set flag = 0;
    if (i > max) then
      leave task;
    end if;
  end loop;
END
;;
delimiter ;

-- ----------------------------
-- Triggers structure for table department
-- ----------------------------
DROP TRIGGER IF EXISTS `trig_leader_before_insert`;
delimiter ;;
CREATE TRIGGER `trig_leader_before_insert` BEFORE INSERT ON `department` FOR EACH ROW BEGIN
  # 查看这个leader是不是其它部门的leader, 如果是，不允许更新
  declare flag int(3) default 0;
  if (NEW.leader is NOT NULL) then
    select count(leader) into flag from department where leader=NEW.leader;
      if (flag != 0) then
        insert into error_tool value(null);
      end if;
  end if;
END
;;
delimiter ;

-- ----------------------------
-- Triggers structure for table department
-- ----------------------------
DROP TRIGGER IF EXISTS `trig_leader_after_insert`;
delimiter ;;
CREATE TRIGGER `trig_leader_after_insert` AFTER INSERT ON `department` FOR EACH ROW BEGIN
   if (NEW.leader is NOT NULL) then
     update user set department_id  = NEW.id where id=NEW.leader;
   end if;
END
;;
delimiter ;

-- ----------------------------
-- Triggers structure for table department
-- ----------------------------
DROP TRIGGER IF EXISTS `trig_leader_before_update`;
delimiter ;;
CREATE TRIGGER `trig_leader_before_update` BEFORE UPDATE ON `department` FOR EACH ROW BEGIN
  # 查看这个leader是不是其它部门的leader, 如果是，不允许更新
  declare flag int(3) default 0;
  if (NEW.leader != OLD.leader) then
    select count(leader) into flag from department where leader=NEW.leader;
      if (flag != 0) then
        insert into error_tool value(null);
      end if;
  end if;
END
;;
delimiter ;

-- ----------------------------
-- Triggers structure for table department
-- ----------------------------
DROP TRIGGER IF EXISTS `trig_leader_after_update`;
delimiter ;;
CREATE TRIGGER `trig_leader_after_update` AFTER UPDATE ON `department` FOR EACH ROW BEGIN
  # leader确定后，user中的leader的department需要是当前的departmentId
  if (NEW.leader != OLD.leader) then
    update user set department_id  = NEW.id where id=NEW.leader;
  end if;
END
;;
delimiter ;

-- ----------------------------
-- Triggers structure for table user
-- ----------------------------
DROP TRIGGER IF EXISTS `trig_for_dep`;
delimiter ;;
CREATE TRIGGER `trig_for_dep` BEFORE UPDATE ON `user` FOR EACH ROW BEGIN
  # 更新user的departmentId前
  # 当用户是1个部门的leader时，不允许修改departmentId
  declare flag int(3) default 0;
  if (OLD.department_id != NEW.department_id) then
    select count(id) into flag from department where leader=NEW.id;
    if (flag != 0) then
      insert into error_tool value(null);
    end if;
  end if;
END
;;
delimiter ;

SET FOREIGN_KEY_CHECKS = 1;
