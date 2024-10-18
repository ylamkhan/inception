#!/bin/sh

# Wait for services like MariaDB to be up and running
sleep 10

# Change to WordPress directory
cd /var/www/html/wordpress

# Check if wp-config.php exists
if [ ! -f "wp-config.php" ]; then
    echo "wp-config.php not found. Setting up WordPress..."

    # Download WordPress core files
    wp core download --allow-root

    # Create wp-config.php with database credentials
    wp config create --allow-root \
                    --dbname="${SQL_DATABASE}" \
                    --dbuser="${SQL_USER}" \
                    --dbpass="${SQL_PASSWORD}" \
                    --dbhost="mariadb:3306" \
                    --path='/var/www/wordpress'

    # Install WordPress core with provided environment variables
    wp core install --allow-root \
                    --url="${DOMAIN_NAME}" \
                    --title="${WP_TITLE}" \
                    --admin_user="${ADMIN_USER}" \
                    --admin_password="${ADMIN_PASSWORD}" \
                    --admin_email="${WP_ADMIN_EMAIL}"

    # Create an additional user with author role
    wp user create --allow-root \
                   "${WP_USER}" \
                   "${WP_EMAIL}" \
                   --role=author \
                   --user_pass="${WP_PASSWORD}"

    # Install and activate Redis cache plugin
    wp plugin install redis-cache --activate --allow-root

    # Update all plugins
    wp plugin update --all --allow-root

    # Enable Redis object caching
    wp redis enable --allow-root

    # Add Redis configuration to wp-config.php if not already present
    if ! grep -q "WP_REDIS_HOST" wp-config.php; then
        echo "Adding Redis configuration to wp-config.php..."
        echo "define( 'WP_REDIS_HOST', 'redis' );" >> wp-config.php
        echo "define( 'WP_REDIS_PORT', 6379 );" >> wp-config.php
        echo "define('WP_CACHE', true);" >> wp-config.php
    else
        echo "Redis configuration already exists in wp-config.php."
    fi
else
    echo "wp-config.php already exists. Skipping WordPress setup."
fi

# Start PHP-FPM to serve WordPress
exec /usr/sbin/php-fpm7.4 -F
