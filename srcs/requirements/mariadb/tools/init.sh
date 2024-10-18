#!/bin/bash

service mariadb start

sleep 2

mysql -e "CREATE DATABASE IF NOT EXISTS $SQL_DATABASE;"
mysql -e "CREATE USER IF NOT EXISTS $SQL_USER@'%' IDENTIFIED BY '$SQL_PASSWORD';"
mysql -e "GRANT ALL PRIVILEGES ON $SQL_DATABASE.* TO $SQL_USER@'%' IDENTIFIED BY '$SQL_PASSWORD';"
mysql -e "FLUSH PRIVILEGES;"
service mariadb stop

exec mysqld_safe --bind-address=0.0.0.0