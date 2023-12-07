FROM php:7-apache

# Basic PHP setup
RUN apt-get update -y && apt-get upgrade -y
RUN apt-get install -y \
    mariadb-client
RUN docker-php-ext-install \
    mysqli \
    pdo \
    pdo_mysql

# Set up apache configuration
RUN a2enmod rewrite
RUN a2dissite 000-default.conf
COPY ./docker/owa.conf /etc/apache2/sites-available/owa.conf
RUN a2ensite owa.conf

# Give PHP a useful amount of RAM
RUN mv "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini"
RUN sed -i "s/memory_limit\s*=/memory_limit = 1024M/g"  "$PHP_INI_DIR/php.ini"

# "Install" OWA and set up permissions
RUN curl -L https://github.com/Open-Web-Analytics/Open-Web-Analytics/releases/download/1.7.8/owa_1.7.8_packaged.tar | tar -x
RUN chgrp -R www-data /var/www/html
RUN find /var/www/html -type f -exec chmod 640 {} \;
RUN find /var/www/html -type d -exec chmod 750 {} \;
RUN chown www-data /var/www/html/owa-data
VOLUME /var/www/html

# Set up the new entrypoint and init scripts we need to setup OWA's state.
COPY ./docker/bin/docker-entrypoint.sh /
COPY ./docker/httpd-init /docker-entrypoint
ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["apache2-foreground"]
