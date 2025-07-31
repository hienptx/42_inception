FROM debian:bookworm-slim

RUN apt-get update && apt-get install -y \
    php8.2-fpm \
    php8.2-common \
    php8.2-mysql \
    php8.2-xml \
    php8.2-mbstring \
    php8.2-curl \
    php8.2-zip \
    php8.2-gd \
    php8.2-intl \
    php8.2-bcmath \
    curl unzip wget \
 && apt-get clean
 
# Download WordPress if not already there
RUN curl -O https://wordpress.org/wordpress-6.8.2.tar.gz && \
    mkdir -p /usr/src/wordpress && \
    tar -xzf wordpress-6.8.2.tar.gz -C /usr/src/ && \
    rm wordpress-6.8.2.tar.gz

# Set working directory
WORKDIR /var/www/html

#Copy the entrypoint script and make it executable
COPY tools/entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

EXPOSE 9000
RUN sed -i 's|^listen = .*|listen = 0.0.0.0:9000|' /etc/php/8.2/fpm/pool.d/www.conf

ENTRYPOINT ["entrypoint.sh"]

CMD ["php-fpm8.2", "-F"]
