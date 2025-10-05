FROM php:8.3-fpm

RUN apt-get update

RUN apt-get install -y \
        git \
        libzip-dev \
        procps \
        rsync \
        unzip \
    && mkdir -p /var/spool/cron/crontabs \
    && echo '* * * * * /var/www/bin/playsmsd /var/www/etc/playsmsd.conf start' > /var/spool/cron/crontabs/www-data \
    && rm -rf /var/lib/apt/lists/*

# Install PHP extensions
ADD https://github.com/mlocati/docker-php-extension-installer/releases/latest/download/install-php-extensions /usr/local/bin/
RUN chmod uga+x /usr/local/bin/install-php-extensions && sync \
    && install-php-extensions \
    gd \
    mysqli \
    pdo \
    pdo_mysql \
    pdo_pgsql \
    xdebug \
    zip \
    @composer \
    && rm /usr/local/bin/install-php-extensions \
    # pevent errors when try to create files at /var/www with user www-data
    && chown -R www-data /var/www

# Workaround to make sure /usr/bin/php exists, some scripts expect it
RUN PHP_PATH=$(which php) && \
    if [ ! -f "/usr/bin/php" ] && [ -n "$PHP_PATH" ] && [ "$PHP_PATH" != "/usr/bin/php" ]; then \
        ln -s /usr/local/bin/php /usr/bin/php; \
    fi

COPY config/php/* /usr/local/etc/php/conf.d/

WORKDIR /var/www/html
RUN mkdir /var/www/scripts
COPY scripts/* /var/www/scripts/
ENTRYPOINT [ "bash", "/var/www/scripts/entrypoint.sh" ]