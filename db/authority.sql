-- --------------------------------------------------------
-- 主机:                           127.0.0.1
-- 服务器版本:                        8.0.19 - MySQL Community Server - GPL
-- 服务器OS:                        Win64
-- HeidiSQL 版本:                  10.2.0.5599
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;


-- Dumping database structure for authority
CREATE DATABASE IF NOT EXISTS `authority` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `authority`;

-- Dumping structure for table authority.tb_admin
CREATE TABLE IF NOT EXISTS `tb_admin` (
  `test` bit(7) DEFAULT NULL,
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '管理员id',
  `username` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '用户名',
  `password` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '密码',
  `salt` varchar(5) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT '' COMMENT '盐值',
  `fullname` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '全名',
  `e_mail` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL COMMENT '邮箱\r\n',
  `sex` varchar(1) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '性别：0女，1男,2保密',
  `birthday` date NOT NULL COMMENT '生日',
  `address` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '地址',
  `phone` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '手机号',
  `role_id` bigint DEFAULT NULL COMMENT '角色编号',
  PRIMARY KEY (`id`,`username`) USING BTREE,
  KEY `role_id` (`role_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT COMMENT='管理员列表';

-- Dumping data for table authority.tb_admin: ~2 rows (大约)
DELETE FROM `tb_admin`;
/*!40000 ALTER TABLE `tb_admin` DISABLE KEYS */;
INSERT INTO `tb_admin` (`test`, `id`, `username`, `password`, `salt`, `fullname`, `e_mail`, `sex`, `birthday`, `address`, `phone`, `role_id`) VALUES
	(b'0000011', 1, 'admin', 'e10adc3949ba59abbe56e057f20f883e', '', 'admin', '123@163.com', '1', '2019-10-01', '杭州上城区', '17702432345', 1),
	(NULL, 2, 'test', 'e10adc3949ba59abbe56e057f20f883e', '', 'test', '789@163.com', '0', '2019-10-01', '杭州', '13502435369', 1);
/*!40000 ALTER TABLE `tb_admin` ENABLE KEYS */;

-- Dumping structure for table authority.tb_menus
CREATE TABLE IF NOT EXISTS `tb_menus` (
  `menu_id` bigint NOT NULL AUTO_INCREMENT COMMENT '菜单编号',
  `title` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '菜单名',
  `icon` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL COMMENT '图标',
  `href` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL COMMENT '资源地址',
  `perms` varchar(500) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL COMMENT '权限',
  `spread` varchar(10) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT 'true：展开，false：不展开',
  `parent_id` bigint NOT NULL COMMENT '父节点',
  `sorting` bigint DEFAULT NULL COMMENT '排序',
  PRIMARY KEY (`menu_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=30 DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT COMMENT='菜单表';

-- Dumping data for table authority.tb_menus: ~29 rows (大约)
DELETE FROM `tb_menus`;
/*!40000 ALTER TABLE `tb_menus` DISABLE KEYS */;
INSERT INTO `tb_menus` (`menu_id`, `title`, `icon`, `href`, `perms`, `spread`, `parent_id`, `sorting`) VALUES
	(1, '首页', '&#xe68e;', '', NULL, 'false', 0, NULL),
	(2, '管理员管理', '', '', '', 'false', 0, NULL),
	(3, '用户管理', '&#xe770;', NULL, NULL, 'false', 0, NULL),
	(4, '监控', '&#xe66f;', NULL, NULL, 'false', 0, NULL),
	(5, '日志', '&#xe621;', '', '', 'false', 0, NULL),
	(6, '角色管理', '', '/roleList', '', 'false', 2, NULL),
	(7, '管理员列表', '', '/adminList', '', 'false', 2, NULL),
	(8, '菜单管理', '&#xe642;', '/menuList', NULL, 'false', 2, NULL),
	(9, '添加用户', '&#xe61f;', '/addUser', NULL, 'false', 3, NULL),
	(10, '管理用户', '&#xe6b2;', '/userManager', NULL, 'false', 3, NULL),
	(11, 'SQL监控', '&#xe642;', '/sys/druid', NULL, 'false', 4, NULL),
	(12, '系统日志', '&#xe66e;', '', NULL, 'false', 5, NULL),
	(13, '查询', '', '', 'sys:role:select', 'false', 6, NULL),
	(14, '新增', NULL, NULL, 'sys:role:insert', 'false', 6, NULL),
	(15, '修改', NULL, NULL, 'sys:role:update', 'false', 6, NULL),
	(16, '删除', '', '', 'sys:role:delete', 'false', 6, NULL),
	(17, '查询', NULL, NULL, 'sys:admin:select', 'false', 7, NULL),
	(18, '新增', NULL, NULL, 'sys:admin:insert', 'false', 7, NULL),
	(19, '修改', NULL, NULL, 'sys:admin:update', 'false', 7, NULL),
	(20, '删除', NULL, NULL, 'sys:admin:delete', 'false', 7, NULL),
	(21, '查询', NULL, NULL, 'sys:menu:select', 'false', 8, NULL),
	(22, '新增', NULL, NULL, 'sys:menu:insert', 'false', 8, NULL),
	(23, '修改', NULL, NULL, 'sys:menu:update', 'false', 8, NULL),
	(24, '删除', NULL, NULL, 'sys:menu:delete', 'false', 8, NULL),
	(25, '添加', NULL, NULL, 'sys:monitor:insert', 'false', 9, NULL),
	(26, '查询', NULL, NULL, 'sys:manage:select', 'false', 10, NULL),
	(27, '修改', NULL, NULL, 'sys:manage:update', 'false', 10, NULL),
	(28, '删除', NULL, NULL, 'sys:manage:delete', 'false', 10, NULL),
	(29, '查询', NULL, NULL, 'sys:log:select', 'false', 11, NULL);
/*!40000 ALTER TABLE `tb_menus` ENABLE KEYS */;

-- Dumping structure for table authority.tb_roles
CREATE TABLE IF NOT EXISTS `tb_roles` (
  `role_id` bigint NOT NULL AUTO_INCREMENT COMMENT '角色编号',
  `role_name` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL COMMENT '角色名',
  `role_remark` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL COMMENT '角色描述',
  PRIMARY KEY (`role_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT COMMENT='角色表';

-- Dumping data for table authority.tb_roles: ~2 rows (大约)
DELETE FROM `tb_roles`;
/*!40000 ALTER TABLE `tb_roles` DISABLE KEYS */;
INSERT INTO `tb_roles` (`role_id`, `role_name`, `role_remark`) VALUES
	(1, '超级管理员', '这是超级管理员，惹不起的'),
	(2, '会员', '这是一个会员');
/*!40000 ALTER TABLE `tb_roles` ENABLE KEYS */;

-- Dumping structure for table authority.tb_roles_menus
CREATE TABLE IF NOT EXISTS `tb_roles_menus` (
  `role_id` bigint NOT NULL COMMENT '角色id',
  `menu_id` bigint NOT NULL COMMENT '菜单id',
  PRIMARY KEY (`menu_id`,`role_id`) USING BTREE,
  KEY `role_id` (`role_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT COMMENT='分配权限（菜单）';

-- Dumping data for table authority.tb_roles_menus: ~162 rows (大约)
DELETE FROM `tb_roles_menus`;
/*!40000 ALTER TABLE `tb_roles_menus` DISABLE KEYS */;
INSERT INTO `tb_roles_menus` (`role_id`, `menu_id`) VALUES
	(1, 1),
	(1, 2),
	(1, 3),
	(1, 4),
	(1, 5),
	(1, 6),
	(1, 7),
	(1, 8),
	(1, 9),
	(1, 10),
	(1, 11),
	(1, 12),
	(1, 13),
	(1, 14),
	(1, 15),
	(1, 16),
	(1, 17),
	(1, 18),
	(1, 19),
	(1, 20),
	(1, 21),
	(1, 22),
	(1, 23),
	(1, 24),
	(1, 25),
	(1, 26),
	(1, 27),
	(1, 28),
	(1, 29),
	(2, 1),
	(2, 2),
	(2, 3),
	(2, 4),
	(2, 5),
	(2, 6),
	(2, 7),
	(2, 8),
	(2, 9),
	(2, 10),
	(2, 11),
	(2, 12),
	(2, 13),
	(2, 14),
	(2, 15),
	(2, 16),
	(2, 17),
	(2, 18),
	(2, 19),
	(2, 20),
	(2, 21),
	(2, 22),
	(2, 23),
	(2, 24),
	(2, 25),
	(2, 26),
	(2, 27),
	(2, 28),
	(4, 1),
	(4, 2),
	(4, 3),
	(4, 4),
	(4, 5),
	(4, 6),
	(4, 7),
	(4, 8),
	(4, 9),
	(4, 10),
	(4, 11),
	(4, 12),
	(4, 13),
	(4, 14),
	(4, 15),
	(5, 1),
	(5, 2),
	(5, 3),
	(5, 4),
	(5, 5),
	(5, 6),
	(5, 7),
	(5, 8),
	(5, 9),
	(5, 10),
	(5, 11),
	(5, 12),
	(5, 13),
	(5, 14),
	(5, 15),
	(6, 1),
	(6, 2),
	(6, 3),
	(6, 4),
	(6, 5),
	(6, 6),
	(6, 7),
	(6, 8),
	(6, 9),
	(6, 10),
	(6, 11),
	(6, 12),
	(6, 13),
	(6, 14),
	(6, 15),
	(7, 1),
	(7, 2),
	(7, 3),
	(7, 4),
	(7, 5),
	(7, 6),
	(7, 7),
	(7, 8),
	(7, 9),
	(7, 10),
	(7, 11),
	(7, 12),
	(7, 13),
	(7, 14),
	(7, 15),
	(8, 1),
	(8, 2),
	(8, 3),
	(8, 4),
	(8, 5),
	(8, 6),
	(8, 7),
	(8, 8),
	(8, 9),
	(8, 10),
	(8, 11),
	(8, 12),
	(8, 13),
	(8, 14),
	(8, 15),
	(11, 1),
	(11, 2),
	(11, 3),
	(11, 4),
	(11, 5),
	(11, 6),
	(11, 7),
	(11, 8),
	(11, 9),
	(11, 10),
	(11, 11),
	(11, 12),
	(11, 13),
	(11, 14),
	(11, 15),
	(12, 1),
	(12, 2),
	(12, 3),
	(12, 4),
	(12, 5),
	(12, 6),
	(12, 7),
	(12, 8),
	(12, 9),
	(12, 10),
	(12, 11),
	(12, 12),
	(12, 13),
	(12, 14),
	(12, 15);
/*!40000 ALTER TABLE `tb_roles_menus` ENABLE KEYS */;

-- Dumping structure for table authority.tb_users
CREATE TABLE IF NOT EXISTS `tb_users` (
  `uid` bigint unsigned NOT NULL AUTO_INCREMENT,
  `e_mail` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `nickname` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '昵称：唯一',
  `password` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `sex` varchar(1) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '0:女，1:男，2：保密',
  `birthday` date NOT NULL,
  `address` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `phone` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL,
  `e_code` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `status` varchar(1) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL COMMENT '0:未激活，1，正常，2，禁用',
  `create_time` datetime NOT NULL,
  PRIMARY KEY (`uid`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=37 DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;

-- Dumping data for table authority.tb_users: ~3 rows (大约)
DELETE FROM `tb_users`;
/*!40000 ALTER TABLE `tb_users` DISABLE KEYS */;
INSERT INTO `tb_users` (`uid`, `e_mail`, `nickname`, `password`, `sex`, `birthday`, `address`, `phone`, `e_code`, `status`, `create_time`) VALUES
	(33, '593151321@qq.com', 'ttt', 'bd9b42cb3774f880056197b09c2bf9d6', '1', '2019-10-22', '233199', '23456', 'c7edba306fab4098ac1c0b5877649b8a388', '1', '2019-10-26 21:05:41'),
	(35, '1253210906@qq.com', 'aaaaa', '5b5313fc19867a00f6d28d536d81d4c7', '0', '2019-10-03', '杭州', '17702431146', 'cb1e612219ec40bb910ab55de48983dd113', '0', '2019-10-27 21:54:42'),
	(36, '123@qq.com', 'topy', 'f509f5c5e0ded84ba7d530736a72a211', '0', '2019-10-09', '杭州', '17702431146', '8aeb69d8f1fd4f86b8577a1bd2277f4a283', '2', '2019-10-26 21:52:30');
/*!40000 ALTER TABLE `tb_users` ENABLE KEYS */;

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
