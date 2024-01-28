# Start from a PHP image
FROM php:8.1-fpm

# Install Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Install necessary PHP extensions
RUN docker-php-ext-install pdo_mysql

# Set working directory
WORKDIR /app

# Copy composer.json and composer.lock files to the container
COPY composer.json composer.lock ./

# Install dependencies with Composer
RUN composer install --no-scripts --no-autoloader

# Copy the rest of the application to the container
COPY . app/

# Generate autoloader with classmap optimization
RUN composer dump-autoload --optimize

# Expose port 80
EXPOSE 80

# Start PHP's built-in server
CMD ["php", "-S", "0.0.0.0:80", "-t", "public"]