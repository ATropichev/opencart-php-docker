FROM php:7.3-apache
RUN apt-get update && apt-get install -y \
		libfreetype6-dev \
		libjpeg62-turbo-dev \
		libpng-dev \
		libzip-dev \
	&& docker-php-ext-configure gd --with-freetype --with-jpeg \
	&& docker-php-ext-configure zip \
	&& docker-php-ext-configure zip \
	&& docker-php-ext-install -j$(nproc) gd zip mysqli
RUN rm -rf /var/www/html
