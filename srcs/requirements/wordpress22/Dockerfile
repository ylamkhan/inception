FROM debian:bullseye

# Install dependencies and PHP
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y wget

RUN apt-get install -y php7.3 \
    php-fpm \
    php-mysql \
    mariadb-client

# Download and setup WP-CLI
RUN wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
RUN chmod +x wp-cli.phar
RUN cp wp-cli.phar /usr/bin/wp

# Create necessary directories
RUN mkdir -p /run/php/

# Download WordPress and set permissions
RUN wget https://fr.wordpress.org/wordpress-6.0-fr_FR.tar.gz -P /var/www
RUN cd /var/www && tar -xzf wordpress-6.0-fr_FR.tar.gz && rm wordpress-6.0-fr_FR.tar.gz
RUN chown -R root:root /var/www/wordpress

# Copy the script to the container
COPY ./tools/script.sh /var/www/script.sh

# Add this line to PHP FPM config
RUN echo "listen = wordpress:9000" >> /etc/php/7.4/fpm/php-fpm.conf
RUN chmod +x /var/www/script.sh

# Run the script
CMD ["sh", "/var/www/script.sh"]
