FROM ubuntu:14.04
MAINTAINER Fausto Carrera <fausto.carrera@gmx.com>

ENV DEBIAN_FRONTEND noninteractive

# Install neccesary software
RUN apt-get update
RUN apt-get install -y --no-install-recommends ca-certificates
RUN apt-get install -y --no-install-recommends git
RUN apt-get install -y --no-install-recommends zip
RUN apt-get install -y --no-install-recommends curl
RUN apt-get install -y --no-install-recommends nginx
RUN apt-get install -y --no-install-recommends sqlite3
RUN apt-get install -y --no-install-recommends php5
RUN apt-get install -y --no-install-recommends php5-curl
RUN apt-get install -y --no-install-recommends php5-fpm
RUN apt-get install -y --no-install-recommends php5-intl
RUN apt-get install -y --no-install-recommends php5-sqlite
RUN apt-get install -y --no-install-recommends php5-pgsql
RUN apt-get install -y --no-install-recommends php5-mysqlnd
RUN apt-get install -y --no-install-recommends php5-memcache
RUN apt-get install -y --no-install-recommends php5-apcu
RUN apt-get install -y --no-install-recommends supervisor

# Configure PHP-FPM & Nginx
RUN sed -e 's/;daemonize = yes/daemonize = no/' -i /etc/php5/fpm/php-fpm.conf
RUN sed -e 's/;listen\.owner/listen.owner/' -i /etc/php5/fpm/pool.d/www.conf
RUN sed -e 's/;listen\.group/listen.group/' -i /etc/php5/fpm/pool.d/www.conf
RUN echo "opcache.enable=1" >> /etc/php5/mods-available/opcache.ini
RUN echo "opcache.enable_cli=1" >> /etc/php5/mods-available/opcache.ini
RUN echo "\ndaemon off;" >> /etc/nginx/nginx.conf
RUN echo "\ndate.timezone = \"UTC\"" >> /etc/php5/cli/php.ini
COPY docker/supervisor.conf /etc/supervisor/conf.d/supervisor.conf
COPY docker/vhost.conf /etc/nginx/sites-available/default
RUN usermod -u 1000 www-data

# Composer
RUN curl -sSk https://getcomposer.org/installer | php
RUN mv composer.phar /usr/bin/composer
RUN chmod a+x /usr/bin/composer

# Symfony
ADD . /var/www
WORKDIR /var/www
RUN chmod -R 777 app/cache
RUN composer install --no-plugins --no-scripts -vvv
EXPOSE 80

CMD ["/usr/bin/supervisord"]