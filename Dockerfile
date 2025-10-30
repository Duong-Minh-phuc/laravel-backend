# Sử dụng PHP 8.2 có sẵn Composer
FROM php:8.2-apache

# Cài các extension cần thiết cho Laravel
RUN apt-get update && apt-get install -y \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    zip \
    git \
    unzip \
    && docker-php-ext-install pdo_mysql gd

# Bật mod_rewrite để Laravel routing hoạt động
RUN a2enmod rewrite

# Copy mã nguồn vào container
COPY . /var/www/html

# Cài đặt dependencies Laravel
WORKDIR /var/www/html
RUN curl -sS https://getcomposer.org/installer | php
RUN php composer.phar install --no-dev --optimize-autoloader

# Phân quyền storage và bootstrap
RUN chown -R www-data:www-data /var/www/html/storage /var/www/html/bootstrap/cache

# Mở port 80
EXPOSE 80

# Lệnh chạy server
CMD ["apache2-foreground"]
