#!/bin/bash
set -e

# Initialize database if not exists
if [ ! -d "/var/lib/mysql/mysql" ]; then
    echo "Initializing MariaDB database..."
    
    # Initialize the database system tables
    mariadb-install-db --user=mysql --datadir=/var/lib/mysql
    
    # Start temporary server for initial setup
    mysqld --user=mysql --skip-networking --socket=/tmp/mysql.sock &
    MYSQL_PID=$!
    
    # Wait for server to start
    echo "Waiting for MariaDB to start..."
    until mysqladmin ping -S /tmp/mysql.sock --silent 2>/dev/null; do
        sleep 1
    done
    echo "MariaDB started successfully"
    
    # Setup root password and create WordPress database/user
    mysql -S /tmp/mysql.sock <<EOF
-- Set root password
ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';

-- Create WordPress database
CREATE DATABASE IF NOT EXISTS \`${MYSQL_DATABASE}\`;

-- Create WordPress database user
CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
GRANT ALL PRIVILEGES ON \`${MYSQL_DATABASE}\`.* TO '${MYSQL_USER}'@'%';

-- Allow root connections from anywhere (for development)
CREATE USER IF NOT EXISTS 'root'@'%' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';
GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' WITH GRANT OPTION;

FLUSH PRIVILEGES;
EOF
    
    echo "Database initialization completed"
    
    # Stop temporary server
    kill $MYSQL_PID
    wait $MYSQL_PID 2>/dev/null || true
fi

echo "Starting MariaDB server..."
# Execute the main command (mysqld)
exec "$@"