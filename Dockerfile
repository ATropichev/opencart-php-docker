FROM php:7.3-apache
RUN apt-get update && apt-get install -y \
		libfreetype6-dev \
		libjpeg62-turbo-dev \
		libpng-dev \
		libzip-dev \
		libxml2-dev \
	&& docker-php-ext-configure gd --with-jpeg-dir --with-png-dir \
	&& docker-php-ext-configure zip \
	&& docker-php-ext-configure mysqli \
	&& docker-php-ext-configure simplexml \
	&& docker-php-ext-install -j$(nproc) gd zip mysqli simplexml
RUN a2dismod rpaf \
	&& a2enmod remoteip \
	&& a2enmod rewrite
RUN rm -rf /var/www/html
