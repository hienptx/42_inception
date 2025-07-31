#!/bin/sh -e

# Check if WordPress is already installed
if [ ! -f /var/www/html/index.php ] || [ ! -d /var/www/html/wp-includes ]; then
    echo "WordPress not found. Copying files..." >&2
    cp -a /usr/src/wordpress/. /var/www/html/
    chown -R www-data:www-data /var/www/html
fi

# Execute the CMD
exec "$@"
