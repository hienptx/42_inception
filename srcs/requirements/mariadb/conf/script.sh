#!/bin/bash
set -e

echo "Setting up MariaDB directories..."
mkdir -p /var/run/mysqld
chown -R mysql:mysql /var/run/mysqld

# Only initialize if the DB is not already set up
if [ ! -d "/var/lib/mysql/mysql" ]; then
    echo "Starting MariaDB for initialization..."
    mysqld_safe --skip-networking &
    pid="$!"

    echo "Waiting for MariaDB to start..."
    until mysqladmin ping --silent; do
        echo "Waiting..."
        sleep 2
    done

    echo "Create Database..."
    mysql -u root -e "CREATE DATABASE IF NOT EXISTS \`${MYSQL_DATABASE}\`;"

    echo "Create User for % and localhost..."
    mysql -u root -e "CREATE USER IF NOT EXISTS \`${MYSQL_USER}\`@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';"
    mysql -u root -e "CREATE USER IF NOT EXISTS \`${MYSQL_USER}\`@'localhost' IDENTIFIED BY '${MYSQL_PASSWORD}';"

    echo "Grant all privileges..."
    mysql -u root -e "GRANT ALL PRIVILEGES ON \`${MYSQL_DATABASE}\`.* TO \`${MYSQL_USER}\`@'%';"
    mysql -u root -e "GRANT ALL PRIVILEGES ON \`${MYSQL_DATABASE}\`.* TO \`${MYSQL_USER}\`@'localhost';"
    echo "alter root"
    echo "MYSQL_ROOT_PASSWORD is: '${MYSQL_ROOT_PASSWORD}'"
    mysql -u root -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';"

    echo "flush privileges"
    mysql -u root -e "FLUSH PRIVILEGES;"

    # Now use the password for shutdown
    mysqladmin -u root -p"${MYSQL_ROOT_PASSWORD}" shutdown

    wait "$pid"
fi

# Start MariaDB in the foreground for the container
exec mysqld_safe