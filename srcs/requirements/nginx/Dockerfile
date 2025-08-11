FROM debian:bullseye-slim

RUN apt-get update && apt-get install -y nginx openssl

# Self-signed certificate
RUN openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
  -keyout /etc/ssl/private/hipham.key \
  -out /etc/ssl/certs/hipham.crt \
  -subj "/CN=hien.42.heilbronn.de/O=hipham/C=DE"

COPY conf/nginx.conf /etc/nginx/nginx.conf

WORKDIR /var/www/html

CMD ["nginx", "-g", "daemon off;"]
