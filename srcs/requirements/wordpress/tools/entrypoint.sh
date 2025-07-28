#!/bin/sh
set -e

# Wait for MariaDB to be ready
echo "Waiting for database..."
until mysqladmin ping -h"$DB_HOST" --silent; do
  sleep 1
done

# Copy WordPress files if not yet present
if [ ! -f /var/www/html/wp-config.php ]; then
  echo "Setting up WordPress..."
  wp core download --allow-root
  wp config create  --dbname=$DB_DATABASE \
                    --dbuser=$DB_USER \
                    --dbpass=$DB_PASSWORD \
                    --dbhost=$DB_HOST \
                    --allow-root
  wp core install   --url="https://$DOMAIN_NAME" \
                    --title=$WP_TITLE \
                    --admin_user=$WP_ADMIN \
                    --admin_password=$WP_ADMIN_PASS \
                    --admin_email=$WP_ADMIN_EMAIL \
                    --allow-root
fi

exec "$@"
