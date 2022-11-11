FROM php:7.3-apache
RUN apt-get update && apt-get install -y \
		libfreetype6-dev \
		libjpeg62-turbo-dev \
		libpng-dev \
		libwebp-dev \
		libzip-dev \
	&& docker-php-ext-configure gd --with-jpeg-dir --with-webp-dir --with-freetype-dir \
	&& docker-php-ext-configure zip \
	&& docker-php-ext-configure mysqli \
	&& docker-php-ext-install -j$(nproc) gd zip mysqli
RUN a2enmod remoteip \
    && printf '<IfModule mod_remoteip.c>\n\tRemoteIPHeader X-Real-IP\n\tRemoteIPInternalProxy 127.0.0.1 nginx\n</IfModule>' \
    		> /etc/apache2/mods-enabled/remoteip.conf \
    && a2enmod rewrite
# Use the default production configuration
RUN mv "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini"
# Increase php memory_limit up to 128Mb
RUN echo 'memory_limit = 256M' >> /usr/local/etc/php/conf.d/docker-php-memlimit.ini
RUN rm -rf /var/www/html
