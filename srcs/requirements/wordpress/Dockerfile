FROM php:8.2-fpm

RUN apt-get update && apt-get install -y \
    libfreetype-dev \
    libjpeg62-turbo-dev \
    libpng-dev \
    libzip-dev \
    zip \
    unzip \
    libonig-dev \
    libxml2-dev \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j$(nproc) \
        gd \
        mysqli \
        pdo \
        pdo_mysql \
        zip \
        bcmath \
        mbstring \
        xml \
        opcache

COPY tools/*.sh /app/tools/

RUN chmod +x /app/tools/*.sh

WORKDIR /var/www/html

COPY http /var/www/html/

# ENTRYPOINT ["/app/tools/wp-entrypoint.sh"]

CMD ["php-fpm"]

