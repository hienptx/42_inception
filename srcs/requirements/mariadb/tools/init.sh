#!/bin/sh

DB_ROOT_PASS=$(cat /run/secrets/db_root_password)
DB_USER_PASS=$(cat /run/secrets/db_password)

mariadb -uroot -p"$DB_ROOT_PASS" <<EOF
CREATE DATABASE IF NOT EXISTS wordpress;
CREATE USER IF NOT EXISTS 'wpuser'@'%' IDENTIFIED BY '${DB_USER_PASS}';
GRANT ALL PRIVILEGES ON wordpress.* TO 'wpuser'@'%';
FLUSH PRIVILEGES;
EOF