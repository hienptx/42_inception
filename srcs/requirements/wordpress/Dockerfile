FROM debian:bullseye-slim

# Install PHP-FPM, required PHP extensions, and MariaDB client
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        php7.4-fpm \
        php7.4-mysql \
        php7.4-curl \
        php7.4-gd \
        php7.4-xml \
        php7.4-mbstring \
        php7.4-zip \
        mariadb-client \
        curl \
        less \
        unzip \
        ca-certificates && \
    rm -rf /var/lib/apt/lists/*

# Create directory for PHP-FPM socket
RUN mkdir -p /run/php

# Configure PHP-FPM to listen on TCP port instead of Unix socket
RUN sed -i 's|listen = /run/php/php7.4-fpm.sock|listen = 9000|' /etc/php/7.4/fpm/pool.d/www.conf

# Install WP-CLI
RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
    chmod +x wp-cli.phar && mv wp-cli.phar /usr/local/bin/wp

# Copy custom entrypoint script
COPY tools/entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

# Set working directory
WORKDIR /var/www/html

EXPOSE 9000

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
CMD ["php-fpm7.4", "-F"]