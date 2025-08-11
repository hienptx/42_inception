#!/bin/bash
set -e

# Ensure the directory exists and has correct permissions
mkdir -p /var/www/html
chmod -R 777 /var/www/html  # Ensure anyone can write

# Wait for MariaDB to be ready
echo "Waiting for MariaDB at ${WORDPRESS_DB_HOST}..."
until mysqladmin ping -h"${WORDPRESS_DB_HOST}" --silent; do
    sleep 1
done
echo "MariaDB is ready."

# Install WordPress if not already set up
if [ ! -f "${WP_PATH}/wp-config.php" ]; then
    echo "Installing WordPress..."

    # Download WordPress
    wp core download --path="${WP_PATH}" --allow-root

    # Create wp-config.php
    wp config create \
        --path="${WP_PATH}" \
        --dbname="${WORDPRESS_DB_NAME}" \
        --dbuser="${WORDPRESS_DB_USER}" \
        --dbpass="${WORDPRESS_DB_PASSWORD}" \
        --dbhost="${WORDPRESS_DB_HOST}" \
        --allow-root

    # Install WordPress core
    wp core install \
        --path="${WP_PATH}" \
        --url="${WP_URL}" \
        --title="WordPress Site" \
        --admin_user="${WP_ADMIN_USER}" \
        --admin_password="${WP_ADMIN_PASSWORD}" \
        --admin_email="${WP_ADMIN_EMAIL}" \
        --skip-email \
        --allow-root

    # Create a regular user if not exists
    if ! wp user get "${WP_USER_LOGIN}" --path="${WP_PATH}" --allow-root >/dev/null 2>&1; then
        wp user create \
            "${WP_USER_LOGIN}" \
            "${WP_USER_EMAIL}" \
            --user_pass="${WP_USER_PASSWORD}" \
            --role=subscriber \
            --path="${WP_PATH}" \
            --allow-root
    fi
fi

# Start PHP-FPM
exec "$@"
