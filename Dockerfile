FROM alpine:3.10

ADD https://dl.bintray.com/php-alpine/key/php-alpine.rsa.pub /etc/apk/keys/php-alpine.rsa.pub

RUN apk --update add ca-certificates

RUN echo "http://dl.bintray.com/php-alpine/v3.10/php-7.4/" >> /etc/apk/repositories

RUN apk add --update \
    bash \
    curl \
    git \
    unzip \
    php \
    php-phar \
    php-bcmath \
    php-calendar \
    php-mbstring \
    php-exif \
    php-ftp \
    php-openssl \
    php-zip \
    php-sysvsem \
    php-sysvshm \
    php-sysvmsg \
    php-shmop \
    php-sockets \
    php-zlib \
    php-bz2 \
    php-curl \
    php-xml \
    php-opcache \
    php-dom \
    php-xmlreader \
    php-ctype \
    php-session \
    php-iconv \
    php-json \
    php-posix \
    php-gd \
    #php-xdebug \
    php-pgsql \
    php-sqlite3 \
    php-pdo \
    php-pdo_mysql \
    php-pdo_pgsql \
    php-pdo_sqlite \
    php-pcntl \
    php-intl
    #php-simplexml \
    #php-xmlwriter \
    #php-tokenizer \
    #php-fileinfo \

RUN ln -s /usr/bin/php7 /usr/bin/php

WORKDIR /tmp

RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" \
    && php composer-setup.php --install-dir=/usr/bin --filename=composer \
    && php -r "unlink('composer-setup.php');" \
    && composer require "phpunit/phpunit:^8.5" --prefer-source --no-interaction \
    && composer require "phpunit/php-invoker" --prefer-source --no-interaction \
    && ln -s /tmp/vendor/bin/phpunit /usr/local/bin/phpunit \
    && sed -i 's/nn and/nn, Nicolas Frey (Docker) and/g' /tmp/vendor/phpunit/phpunit/src/Runner/Version.php

VOLUME ["/app"]
WORKDIR /app

ENTRYPOINT ["/usr/local/bin/phpunit"]
