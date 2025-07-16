#!/bin/sh
set -e

# Wait for MariaDB to be ready
echo "Waiting for database..."
until mysqladmin ping -h"$MYSQL_HOST" --silent; do
  sleep 1
done

# Copy WordPress files if not yet present
if [ ! -f /var/www/html/wp-config.php ]; then
  echo "Setting up WordPress..."
  wp core download --allow-root
  wp config create --dbname=$MYSQL_DATABASE --dbuser=$MYSQL_USER --dbpass=$MYSQL_PASSWORD --dbhost=$MYSQL_HOST --allow-root
  wp core install --url="https://$DOMAIN_NAME" --title="Inception" --admin_user=$WP_ADMIN --admin_password=$WP_ADMIN_PASS --admin_email=$WP_ADMIN_EMAIL --allow-root
fi

exec "$@"
