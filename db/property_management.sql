-- 创建数据库
CREATE DATABASE IF NOT EXISTS property_management DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

USE property_management;

-- 角色表
CREATE TABLE IF NOT EXISTS sys_role (
    id INT AUTO_INCREMENT PRIMARY KEY COMMENT '角色ID',
    role_name VARCHAR(50) NOT NULL COMMENT '角色名称',
    role_code VARCHAR(50) NOT NULL COMMENT '角色编码',
    description VARCHAR(255) COMMENT '角色描述',
    status INT DEFAULT 1 COMMENT '状态：1启用，0禁用'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='系统角色表';

-- 菜单表
CREATE TABLE IF NOT EXISTS sys_menu (
    id INT AUTO_INCREMENT PRIMARY KEY COMMENT '菜单ID',
    menu_name VARCHAR(50) NOT NULL COMMENT '菜单名称',
    path VARCHAR(255) COMMENT '菜单路径',
    component VARCHAR(255) COMMENT '组件路径',
    icon VARCHAR(50) COMMENT '菜单图标',
    parent_id INT DEFAULT 0 COMMENT '父菜单ID',
    order_num INT DEFAULT 0 COMMENT '排序号',
    visible INT DEFAULT 1 COMMENT '是否可见：1是，0否',
    status INT DEFAULT 1 COMMENT '状态：1启用，0禁用'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='系统菜单表';

-- 用户表
CREATE TABLE IF NOT EXISTS sys_user (
    id BIGINT AUTO_INCREMENT PRIMARY KEY COMMENT '用户ID',
    username VARCHAR(50) NOT NULL UNIQUE COMMENT '用户名',
    password VARCHAR(100) NOT NULL COMMENT '密码',
    real_name VARCHAR(50) COMMENT '真实姓名',
    phone VARCHAR(20) COMMENT '手机号',
    email VARCHAR(100) COMMENT '邮箱',
    role_id INT COMMENT '角色ID',
    status INT DEFAULT 1 COMMENT '状态：1启用，0禁用',
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    update_time DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    FOREIGN KEY (role_id) REFERENCES sys_role(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='系统用户表';

-- 楼栋表
CREATE TABLE IF NOT EXISTS building (
    id BIGINT AUTO_INCREMENT PRIMARY KEY COMMENT '楼栋ID',
    building_name VARCHAR(50) NOT NULL COMMENT '楼栋名称',
    unit_count INT DEFAULT 0 COMMENT '单元数',
    status INT DEFAULT 1 COMMENT '状态：1启用，0禁用',
    description VARCHAR(255) COMMENT '描述'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='楼栋表';

-- 房屋表
CREATE TABLE IF NOT EXISTS house (
    id BIGINT AUTO_INCREMENT PRIMARY KEY COMMENT '房屋ID',
    building_id BIGINT COMMENT '楼栋ID',
    unit VARCHAR(20) COMMENT '单元',
    room_number VARCHAR(20) NOT NULL COMMENT '房间号',
    house_type VARCHAR(50) COMMENT '户型',
    area DOUBLE COMMENT '面积',
    status INT DEFAULT 0 COMMENT '状态：0空闲，1已入住',
    description VARCHAR(255) COMMENT '描述',
    FOREIGN KEY (building_id) REFERENCES building(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='房屋表';

-- 业主信息表
CREATE TABLE IF NOT EXISTS owner_info (
    id BIGINT AUTO_INCREMENT PRIMARY KEY COMMENT '业主ID',
    name VARCHAR(50) NOT NULL COMMENT '业主姓名',
    id_card VARCHAR(20) NOT NULL COMMENT '身份证号',
    phone VARCHAR(20) COMMENT '手机号',
    email VARCHAR(100) COMMENT '邮箱',
    house_id BIGINT COMMENT '房屋ID',
    status INT DEFAULT 1 COMMENT '状态：1正常，0禁用',
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    update_time DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    FOREIGN KEY (house_id) REFERENCES house(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='业主信息表';

-- 报修表
CREATE TABLE IF NOT EXISTS repair (
    id BIGINT AUTO_INCREMENT PRIMARY KEY COMMENT '报修ID',
    owner_id BIGINT COMMENT '业主ID',
    house_id BIGINT COMMENT '房屋ID',
    title VARCHAR(100) NOT NULL COMMENT '报修标题',
    content TEXT COMMENT '报修内容',
    images VARCHAR(500) COMMENT '图片路径',
    status INT DEFAULT 0 COMMENT '状态：0待处理，1处理中，2已完成',
    handler VARCHAR(50) COMMENT '处理人',
    handle_content TEXT COMMENT '处理内容',
    rating INT COMMENT '评分：1-5',
    comment TEXT COMMENT '评价内容',
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    update_time DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    FOREIGN KEY (owner_id) REFERENCES owner_info(id),
    FOREIGN KEY (house_id) REFERENCES house(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='报修表';

-- 费用表
CREATE TABLE IF NOT EXISTS fee (
    id BIGINT AUTO_INCREMENT PRIMARY KEY COMMENT '费用ID',
    house_id BIGINT COMMENT '房屋ID',
    owner_id BIGINT COMMENT '业主ID',
    fee_type VARCHAR(50) NOT NULL COMMENT '费用类型',
    amount DOUBLE NOT NULL COMMENT '金额',
    period VARCHAR(20) NOT NULL COMMENT '周期',
    status INT DEFAULT 0 COMMENT '状态：0未缴费，1已缴费',
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    pay_time DATETIME COMMENT '缴费时间',
    FOREIGN KEY (house_id) REFERENCES house(id),
    FOREIGN KEY (owner_id) REFERENCES owner_info(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='费用表';

-- 公告表
CREATE TABLE IF NOT EXISTS notice (
    id BIGINT AUTO_INCREMENT PRIMARY KEY COMMENT '公告ID',
    title VARCHAR(100) NOT NULL COMMENT '公告标题',
    content TEXT COMMENT '公告内容',
    images VARCHAR(500) COMMENT '图片路径',
    status INT DEFAULT 1 COMMENT '状态：1发布，0草稿',
    top INT DEFAULT 0 COMMENT '是否置顶：1是，0否',
    creator VARCHAR(50) COMMENT '创建人',
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    update_time DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='公告表';

-- 投诉建议表
CREATE TABLE IF NOT EXISTS complaint (
    id BIGINT AUTO_INCREMENT PRIMARY KEY COMMENT '投诉ID',
    owner_id BIGINT COMMENT '业主ID',
    title VARCHAR(100) NOT NULL COMMENT '标题',
    content TEXT COMMENT '内容',
    status INT DEFAULT 0 COMMENT '状态：0待处理，1已处理',
    handler VARCHAR(50) COMMENT '处理人',
    reply_content TEXT COMMENT '回复内容',
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    update_time DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    FOREIGN KEY (owner_id) REFERENCES owner_info(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='投诉建议表';

-- 设施表
CREATE TABLE IF NOT EXISTS facility (
    id BIGINT AUTO_INCREMENT PRIMARY KEY COMMENT '设施ID',
    name VARCHAR(50) NOT NULL COMMENT '设施名称',
    location VARCHAR(100) COMMENT '位置',
    type VARCHAR(50) COMMENT '类型',
    status INT DEFAULT 1 COMMENT '状态：1正常，0故障',
    description VARCHAR(255) COMMENT '描述',
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    update_time DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='设施表';

-- 车位表
CREATE TABLE IF NOT EXISTS parking (
    id BIGINT AUTO_INCREMENT PRIMARY KEY COMMENT '车位ID',
    parking_number VARCHAR(20) NOT NULL COMMENT '车位编号',
    status INT DEFAULT 0 COMMENT '状态：0空闲，1已分配',
    owner_id BIGINT COMMENT '业主ID',
    description VARCHAR(255) COMMENT '描述',
    FOREIGN KEY (owner_id) REFERENCES owner_info(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='车位表';

-- 车辆表
CREATE TABLE IF NOT EXISTS car (
    id BIGINT AUTO_INCREMENT PRIMARY KEY COMMENT '车辆ID',
    owner_id BIGINT COMMENT '业主ID',
    plate_number VARCHAR(20) NOT NULL COMMENT '车牌号',
    car_type VARCHAR(50) COMMENT '车辆类型',
    brand VARCHAR(50) COMMENT '品牌',
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    FOREIGN KEY (owner_id) REFERENCES owner_info(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='车辆表';

-- 初始化数据
-- 角色数据
INSERT INTO sys_role (role_name, role_code, description, status) VALUES
('管理员', 'admin', '系统管理员', 1),
('业主', 'owner', '小区业主', 1);

-- 菜单数据
INSERT INTO sys_menu (menu_name, path, component, icon, parent_id, order_num, visible, status) VALUES
('首页', '/dashboard', 'Dashboard', 'el-icon-s-home', 0, 1, 1, 1),
('业主管理', '/owner', 'Owner', 'el-icon-user', 0, 2, 1, 1),
('楼栋管理', '/building', 'Building', 'el-icon-office-building', 0, 3, 1, 1),
('房屋管理', '/house', 'House', 'el-icon-home', 0, 4, 1, 1),
('报修管理', '/repair', 'Repair', 'el-icon-tools', 0, 5, 1, 1),
('费用管理', '/fee', 'Fee', 'el-icon-money', 0, 6, 1, 1),
('公告管理', '/notice', 'Notice', 'el-icon-message', 0, 7, 1, 1),
('投诉建议', '/complaint', 'Complaint', 'el-icon-warning', 0, 8, 1, 1),
('设施管理', '/facility', 'Facility', 'el-icon-s-tools', 0, 9, 1, 1),
('停车管理', '/parking', 'Parking', 'el-icon-car', 0, 10, 1, 1),
('权限管理', '/permission', 'Permission', 'el-icon-lock', 0, 11, 1, 1),
('个人中心', '/profile', 'Profile', 'el-icon-user-solid', 0, 12, 1, 1);

-- 用户数据（密码：123456）
INSERT INTO sys_user (username, password, real_name, phone, email, role_id, status) VALUES
('admin', 'e10adc3949ba59abbe56e057f20f883e', '管理员', '13800138000', 'admin@example.com', 1, 1),
('owner', 'e10adc3949ba59abbe56e057f20f883e', '业主', '13900139000', 'owner@example.com', 2, 1);

-- 楼栋数据
INSERT INTO building (building_name, unit_count, status, description) VALUES
('1号楼', 3, 1, '1号楼'),
('2号楼', 3, 1, '2号楼'),
('3号楼', 3, 1, '3号楼');

-- 房屋数据
INSERT INTO house (building_id, unit, room_number, house_type, area, status, description) VALUES
(1, '1单元', '101', '两室一厅', 80.5, 1, '1号楼1单元101室'),
(1, '1单元', '201', '两室一厅', 80.5, 1, '1号楼1单元201室'),
(1, '2单元', '101', '三室一厅', 100.0, 0, '1号楼2单元101室'),
(2, '1单元', '101', '两室一厅', 85.0, 1, '2号楼1单元101室'),
(2, '1单元', '201', '三室一厅', 110.0, 0, '2号楼1单元201室'),
(3, '1单元', '101', '两室一厅', 90.0, 1, '3号楼1单元101室');

-- 业主数据
INSERT INTO owner_info (name, id_card, phone, email, house_id, status) VALUES
('张三', '110101199001011234', '13812345678', 'zhangsan@example.com', 1, 1),
('李四', '110101199002022345', '13912345678', 'lisi@example.com', 2, 1),
('王五', '110101199003033456', '13712345678', 'wangwu@example.com', 4, 1),
('赵六', '110101199004044567', '13612345678', 'zhaoliu@example.com', 6, 1);

-- 报修数据
INSERT INTO repair (owner_id, house_id, title, content, images, status, handler, handle_content, rating, comment) VALUES
(1, 1, '水管漏水', '厨房水管漏水严重', '', 2, '管理员', '已修复水管', 5, '服务很好'),
(2, 2, '电路故障', '客厅电灯不亮', '', 1, '管理员', '正在维修', NULL, NULL),
(3, 4, '马桶堵塞', '卫生间马桶堵塞', '', 0, NULL, NULL, NULL, NULL);

-- 费用数据
INSERT INTO fee (house_id, owner_id, fee_type, amount, period, status, pay_time) VALUES
(1, 1, '物业费', 200.0, '2024-01', 1, '2024-01-15 00:00:00'),
(1, 1, '水电费', 150.0, '2024-01', 1, '2024-01-15 00:00:00'),
(2, 2, '物业费', 200.0, '2024-01', 0, NULL),
(4, 3, '物业费', 250.0, '2024-01', 1, '2024-01-20 00:00:00'),
(6, 4, '物业费', 220.0, '2024-01', 0, NULL);

-- 公告数据
INSERT INTO notice (title, content, images, status, top, creator) VALUES
('春节放假通知', '春节期间物业办公室放假安排：2月10日至2月17日放假，2月18日正常上班。', '', 1, 1, '管理员'),
('停水通知', '因管道维修，2月5日上午9:00至下午5:00将暂停供水，请各位业主提前做好储水准备。', '', 1, 0, '管理员'),
('小区活动', '本周六下午2点将在小区广场举办元宵灯谜活动，欢迎各位业主参加。', '', 1, 0, '管理员');

-- 投诉建议数据
INSERT INTO complaint (owner_id, title, content, status, handler, reply_content) VALUES
(1, '小区卫生问题', '小区垃圾清理不及时，希望物业加强管理。', 1, '管理员', '已安排增加清理频次，感谢您的反馈。'),
(2, '车辆乱停乱放', '小区内车辆乱停现象严重，影响通行。', 0, NULL, NULL);

-- 设施数据
INSERT INTO facility (name, location, type, status, description) VALUES
('健身器材', '小区广场', '健身设施', 1, '小区公共健身器材'),
('儿童游乐设施', '小区花园', '儿童设施', 1, '儿童游乐设施'),
('电梯', '1号楼', '电梯', 1, '1号楼电梯'),
('路灯', '小区道路', '照明设施', 0, '部分路灯损坏');

-- 车位数据
INSERT INTO parking (parking_number, status, owner_id, description) VALUES
('A001', 1, 1, '1号楼地下车位'),
('A002', 1, 2, '1号楼地下车位'),
('A003', 0, NULL, '1号楼地下车位'),
('B001', 1, 3, '2号楼地下车位'),
('B002', 0, NULL, '2号楼地下车位');

-- 车辆数据
INSERT INTO car (owner_id, plate_number, car_type, brand) VALUES
(1, '京A12345', '小型轿车', '大众'),
(2, '京B67890', '小型轿车', '丰田'),
(3, '京C24680', 'SUV', '本田'),
(4, '京D13579', '小型轿车', '别克');