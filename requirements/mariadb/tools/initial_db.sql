CREATE DATABASE IF NOT EXISTS wordpress;
CREATE USER IF NOT EXISTS 'binam'@'%' IDENTIFIED BY '123';
GRANT ALL PRIVILEGES ON wordpress.* TO 'binam'@'%';
FLUSH PRIVILEGES;
ALTER USER 'root'@'localhost' IDENTIFIED BY 'root123';