#!/bin/bash
set -e

# Use env vars to get secret file paths or fallback to defaults
ROOT_PASS_FILE="${MYSQL_ROOT_PASSWORD_FILE:-/run/secrets/db_root_password}"
USER_PASS_FILE="${MYSQL_PASSWORD_FILE:-/run/secrets/db_password}"

# Wait for secrets to be available (optional, add if needed)
if [ ! -f "$ROOT_PASS_FILE" ] || [ ! -f "$USER_PASS_FILE" ]; then
  echo "Required secret files not found!"
  exit 1
fi

if [ ! -d "/var/lib/mysql/mysql" ]; then
  echo "Initializing MariaDB data directory..."
  mariadb-install-db --user=mysql --datadir=/var/lib/mysql

  echo "Ensuring proper permissions for socket directory..."
  mkdir -p /var/run/mysqld
  chown -R mysql:mysql /var/run/mysqld

  echo "Starting MariaDB in background..."
  mariadbd --skip-networking &
  pid=$!

  echo "Waiting for MariaDB to start..."
  timeout=30
  while [ $timeout -gt 0 ]; do
    if mysqladmin ping --silent; then
      break
    fi
    sleep 1
    timeout=$((timeout - 1))
  done

  if [ "$timeout" = 0 ]; then
    echo "MariaDB failed to start in time"
    exit 1
  fi

  ROOT_PASS=$(cat "$ROOT_PASS_FILE")
  USER_PASS=$(cat "$USER_PASS_FILE")

  echo "Setting root password..."
  mysql -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '${ROOT_PASS}';"

  if [ -n "$MYSQL_DATABASE" ]; then
    echo "Creating database $MYSQL_DATABASE..."
    mysql -e "CREATE DATABASE IF NOT EXISTS \`${MYSQL_DATABASE}\`;"
  fi

  if [ -n "$MYSQL_USER" ]; then
    echo "Creating user $MYSQL_USER with privileges on $MYSQL_DATABASE..."
    mysql -e "CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${USER_PASS}';"
    mysql -e "GRANT ALL PRIVILEGES ON \`${MYSQL_DATABASE}\`.* TO '${MYSQL_USER}'@'%';"
  fi

  mysql -e "FLUSH PRIVILEGES;"

  echo "Shutting down temporary MariaDB..."
  mysqladmin shutdown

  wait $pid
fi

exec "$@"
