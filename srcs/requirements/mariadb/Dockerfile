FROM debian:bookworm-slim

RUN apt-get update && \
    apt-get install -y mariadb-server && \
    mkdir -p /var/lib/mysql /run/mysqld && \
    chown -R mysql:mysql /var/lib/mysql /run/mysqld && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

COPY tools/entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

# Run entrypoint as root so it can init DB files and start mariadbd properly
USER root

EXPOSE 3306

# HEALTHCHECK --start-period=5m CMD mysqladmin ping -h 127.0.0.1 || exit 1

ENTRYPOINT ["entrypoint.sh"]
CMD ["mariadbd", "--user=mysql"]
