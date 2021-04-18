FROM php:7.3-apache
RUN apt-get update && apt-get install -y \
		libfreetype6-dev \
		libjpeg62-turbo-dev \
		libpng-dev \
		libzip-dev \
	&& docker-php-ext-configure gd --with-jpeg-dir --with-png-dir \
	&& docker-php-ext-configure zip \
	&& docker-php-ext-configure mysqli \
	&& docker-php-ext-install -j$(nproc) gd zip mysqli
#Add xdebug support
RUN pecl install xdebug \
    && docker-php-ext-enable xdebug
#RUN a2enmod remoteip \
#    && printf '<IfModule mod_remoteip.c>\n\tRemoteIPHeader X-Real-IP\n\tRemoteIPInternalProxy 127.0.0.1 nginx\n</IfModule>' \
#    		> /etc/apache2/mods-enabled/remoteip.conf \
RUN a2enmod rewrite
# Use the default production configuration
RUN mv "$PHP_INI_DIR/php.ini-development" "$PHP_INI_DIR/php.ini"
# Add xdebug configuration
RUN printf 'zend_extension=xdebug\n\
xdebug.mode=develop,trace,debug\n\
xdebug.client_host=debuggerhost\n\
xdebug.start_with_request=yes\n' \
    		> $PHP_INI_DIR/conf.d/docker-php-ext-xdebug.ini

RUN rm -rf /var/www/html
