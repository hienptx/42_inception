# Set base image
# syntax=docker/dockerfile:1
# nginx:alpine acts as reverse proxy to PHP-FPM
FROM alpine:3.19

RUN apk update && \
    apk add --no-cache nginx openssl

#Generate self-signed SSL certificate
RUN mkdir -p certs/ && \
    openssl req -x509 -nodes -days 365 \
    -newkey rsa:2048 \
    -keyout /etc/ssl/certs/privkey.pem \
    -out /etc/ssl/certs/fullchain.pem \
    -subj "/CN=hien.42.fr"

# Copy nginx config files -> system-level configuration
# syntax: <source> <destination>
COPY conf/nginx.conf /etc/nginx/nginx.conf

# Set working directory
WORKDIR /app

# Copy tools scripts (entrypoint, check-config, etc.)
COPY tools/*.sh /app/tools/
# COPY http /app/http

# 5. Make sure scripts are executable
RUN chmod +x /app/tools/*.sh

# 6. Set the entrypoint to your script that runs checks then starts nginx
# ENTRYPOINT ["/app/tools/entrypoint.sh"]

# 7. Default command if any (optional)
# daemon off is to
CMD ["nginx", "-g", "daemon off;"]
