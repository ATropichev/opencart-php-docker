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
    && docker-php-ext-enable xdebug \
    && printf '[xdebug]\
zend_extension=xdebug.so
xdebug.profiler_enable=1
xdebug.remote_enable=1
xdebug.remote_handler=dbgp
xdebug.remote_mode=req
xdebug.remote_host=host.docker.internal
xdebug.remote_port=9000
xdebug.remote_autostart=1
xdebug.remote_connect_back=1
xdebug.idekey=PHPSTORM' \
    		> $PHP_INI_DIR/conf.d/docker-php-ext-xdebug.ini
RUN a2enmod remoteip \
    && printf '<IfModule mod_remoteip.c>\n\tRemoteIPHeader X-Real-IP\n\tRemoteIPInternalProxy 127.0.0.1 nginx\n</IfModule>' \
    		> /etc/apache2/mods-enabled/remoteip.conf \
    && a2enmod rewrite
# Use the default production configuration
RUN mv "$PHP_INI_DIR/php.ini-development" "$PHP_INI_DIR/php.ini"
RUN rm -rf /var/www/html
