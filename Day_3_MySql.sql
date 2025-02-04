-- 1 Tao DB
CREATE DATABASE Day_3_MySql;
USE Day_3_MySql;

-- 2 Tao Table User
CREATE TABLE users (
id INT AUTO_INCREMENT PRIMARY KEY,
username VARCHAR(50) unique not null,
email varchar(100) unique not null,
password varchar(50) not null,
created_at timestamp default current_timestamp
);

-- 3 Tao Table Roles
CREATE Table roles (
id int auto_increment primary key,
role_name varchar(20) not null
);

-- 4 Tao Tbale trung gian user_roles ( quan he N-N)
create table user_roles (
user_id int,
role_id int,
primary key (user_id, role_id),
foreign key (user_id) references users(id) on delete cascade,
foreign key (role_id) references roles(id) on delete cascade
);

-- 5 Insert data
insert into users (username, email, password) values
('admin','admin@gmail.com','123456'),
('user1', 'user1@example.com', 'hashed_password1'),
('user2', 'user2@example.com', 'hashed_password2');

INSERT INTO roles (role_name) VALUES ('ADMIN'), ('USER');

INSERT INTO user_roles (user_id, role_id) VALUES (1, 1), (2, 2), (3, 2);

-- 6 Truy van data
select * from users;
select id, username from users where email = 'admin@gmail.com';

-- 7 join ( inner, left, right)
select u.username, r.role_name
from users u
join user_roles ur on u.id = ur.user_id
join roles r on ur.role_id = r.id;

select u.username, r.role_name
from users u
left join user_roles ur on u.id = ur.user_id
left join roles r on ur.role_id = r.id;

select u.username, r.role_name
from users u
right join user_roles ur on u.id = ur.user_id
right join roles r on ur.role_id = r.id;

-- 8 group by having
select role_id, count(user_id) as user_count
from user_roles
group by role_id
having user_count > 1;

select * from users order by created_at desc limit 3;

-- 10 Tao index toi uu hieu suat
create index idx_username on users(username);
create index idx_email on users(email);

-- 11 transaction
start transaction;
update users set email = 'newadmin@gmail.com'
where id = 1;

delete from users where id = 96;
rollback; -- neu co loi
commit; -- xac nhan thanh cong

-- 12 trigger - ghi log them user
create table user_logs (
id int auto_increment primary key,
user_id int,
action varchar(50),
log_time timestamp default current_timestamp
);

DELIMITER //

CREATE TRIGGER after_user_insert
AFTER INSERT ON users
FOR EACH ROW
BEGIN
    INSERT INTO user_logs (user_id, action) VALUES (NEW.id, 'User Created');
END;
//

DELIMITER ;

-- 13 stored producedure - lay user theo email
DELIMITER //

CREATE PROCEDURE getUserByEmail(IN userEmail VARCHAR(100))
BEGIN
    SELECT * FROM users WHERE email = userEmail;
END;
//

DELIMITER ;

-- 14 view tao bang ao xem danh sach user + role
create view user_roles_view as
select u.id,u.username,u.email,r.role_name
from users u
join user_roles ur on u.id = ur.user_id
join roles r on ur.role_id = r.id;

select * from user_roles_view;

-- 15 event tu dong xoa user khong hoat dong sau 30 ngày
DELIMITER //

CREATE EVENT delete_old_users
ON SCHEDULE EVERY 1 DAY
DO
BEGIN
    DELETE FROM users WHERE created_at < NOW() - INTERVAL 30 DAY;
END;
//

DELIMITER ;
