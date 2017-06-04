FROM ubuntu:16.04
MAINTAINER Fausto Carrera <fausto.carrera@gmx.com>

ENV DEBIAN_FRONTEND noninteractive

# Install neccesary software
RUN apt-get update
RUN apt-get install -y ca-certificates git zip curl nginx supervisor
RUN apt-get install -y php php-curl php-fpm php-intl php-pgsql php-mysqlnd php-memcache php-apcu

# Configure PHP-FPM & Nginx
RUN sed -e 's/;daemonize = yes/daemonize = no/' -i /etc/php/7.0/fpm/php-fpm.conf
RUN sed -e 's/;listen\.owner/listen.owner/' -i /etc/php/7.0/fpm/pool.d/www.conf
RUN sed -e 's/;listen\.group/listen.group/' -i /etc/php/7.0/fpm/pool.d/www.conf
RUN echo "opcache.enable=1" >> /etc/php/7.0/mods-available/opcache.ini
RUN echo "opcache.enable_cli=1" >> /etc/php/7.0/mods-available/opcache.ini

RUN echo "" >> /etc/php/7.0/cli/php.ini
RUN echo "date.timezone = \"UTC\"" >> /etc/php/7.0/cli/php.ini

RUN echo "" >> /etc/nginx/nginx.conf
RUN echo "daemon off;" >> /etc/nginx/nginx.conf

COPY docker-config/supervisor.conf /etc/supervisor/conf.d/supervisor.conf
COPY docker-config/vhost.conf /etc/nginx/sites-available/default
RUN mkdir -p /run/php && touch /var/run/php-fpm.sock && touch /run/php/php7.0-fpm.sock
RUN usermod -u 1000 www-data

# test
RUN mkdir /var/www/web
WORKDIR /var/www/web
RUN touch app.php
RUN echo '<?php' >> app.php
RUN echo 'phpinfo();' >> app.php

EXPOSE 80

CMD ["/usr/bin/supervisord"]