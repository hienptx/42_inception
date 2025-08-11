FROM debian:bullseye-slim

# Install MariaDB and clean up in single layer to reduce image size
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        mariadb-server \
        mariadb-client && \
    rm -rf /var/lib/apt/lists/* && \
    rm -rf /var/lib/mysql/* && \
    mkdir -p /var/lib/mysql /var/run/mysqld && \
    chown -R mysql:mysql /var/lib/mysql /var/run/mysqld && \
    chmod 755 /var/run/mysqld

# Copy entrypoint script
COPY tools/entrypoint.sh /usr/local/bin/entrypoint.sh
COPY conf/50-server.cnf /etc/mysql/mariadb.conf.d/50-server.cnf
RUN chmod +x /usr/local/bin/entrypoint.sh
RUN chmod 644 /etc/mysql/mariadb.conf.d/50-server.cnf

# Create directory for custom config if needed
# RUN mkdir -p /etc/mysql/conf.d

# Switch to mysql user for security (entrypoint can still do root tasks if needed)
USER mysql

EXPOSE 3306

# Enable healthcheck with proper timing for MariaDB startup
HEALTHCHECK --start-period=30s --interval=30s --timeout=10s --retries=3 \
    CMD mysqladmin ping -h localhost --silent || exit 1

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
CMD ["mysqld", "--user=mysql", "--bind-address=0.0.0.0"]