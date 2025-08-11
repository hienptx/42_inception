# Connect to MariaDB container
docker exec -it mariadb bash

# Connect to MySQL (already installed in this container)
mariadb -u wpuser -p'wpPassword' wordpress

# Or connect as root
mariadb -u root -p'yourRootPassword'

# Show databases
SHOW DATABASES;

# Use WordPress database
USE wordpress;

# Show tables
SHOW TABLES;

# Query data
SELECT * FROM wp_users;

-- Users
SELECT ID, user_login, user_email FROM wp_users;

-- Posts
SELECT ID, post_title, post_status, post_type FROM wp_posts LIMIT 10;

-- Options (WordPress settings)
SELECT option_name, option_value FROM wp_options WHERE autoload='yes';

-- Schema information
DESCRIBE wp_posts;