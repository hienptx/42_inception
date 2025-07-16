# Set base image
# syntax=docker/dockerfile:1
# nginx:alpine acts as reverse proxy to PHP-FPM
FROM alpine:3.19

RUN apk update && \
    apk add --no-cache nginx

# Copy nginx config files -> system-level configuration
# syntax: <source> <destination>
COPY conf/nginx.conf /etc/nginx/nginx.conf

# Set working directory
WORKDIR /app

# Copy tools scripts (entrypoint, check-config, etc.)
COPY tools/*.sh /app/tools/
COPY srcs/requirements/wordpress/http /app/http

# 5. Make sure scripts are executable
RUN chmod +x /app/tools/*.sh

# 6. Set the entrypoint to your script that runs checks then starts nginx
ENTRYPOINT ["/app/tools/entrypoint.sh"]

# 7. Default command if any (optional)
CMD ["nginx", "-g", "daemon off;"]
