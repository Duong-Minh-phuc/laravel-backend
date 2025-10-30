# Sử dụng PHP 8.2 với Apache
FROM php:8.2-apache

# Cài extension cần cho Laravel
RUN apt-get update && apt-get install -y \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    zip \
    git \
    unzip \
    && docker-php-ext-install pdo_mysql gd

# Bật mod_rewrite (Laravel routing)
RUN a2enmod rewrite

# ✅ Trỏ Apache DocumentRoot vào thư mục public
RUN sed -i 's|/var/www/html|/var/www/html/public|g' /etc/apache2/sites-available/000-default.conf

# Copy source code vào container
COPY . /var/www/html

# Cài Composer
WORKDIR /var/www/html
RUN curl -sS https://getcomposer.org/installer | php \
 && php composer.phar install --no-dev --optimize-autoloader \
 && rm composer.phar

# ✅ Phân quyền cho thư mục cần ghi
RUN chown -R www-data:www-data /var/www/html/storage /var/www/html/bootstrap/cache

# ✅ Bổ sung quyền đọc cho toàn bộ source
RUN chmod -R 755 /var/www/html

# Mở port 80
EXPOSE 80

# Chạy Apache
CMD ["apache2-foreground"]
