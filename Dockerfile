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
RUN a2enmod remoteip \
    && echo '<IfModule mod_remoteip.c>
        RemoteIPHeader X-Real-IP
        RemoteIPInternalProxy 127.0.0.1 nginx
</IfModule>' > /etc/apache2/mods-enabled/remoteip.conf \
    && a2enmod rewrite
RUN rm -rf /var/www/html
