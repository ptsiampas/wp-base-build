FROM wordpress:5.2.2-php7.1-fpm

LABEL maintainer='Peter Tsiampas <peter@tsiampas.com>'

RUN apt-get update
RUN apt-get install --no-install-recommends -y tidy csstidy nano netcat

RUN mkdir -p /usr/src/php/ext

# Install needed php extensions: memcached
#
RUN apt-get install -y libpq-dev libmemcached-dev zlib1g-dev && \
    curl -o memcached.tgz -SL http://pecl.php.net/get/memcached-3.0.3.tgz && \
        tar -xf memcached.tgz -C /usr/src/php/ext/ && \
        echo extension=memcached.so >> /usr/local/etc/php/conf.d/memcached.ini && \
        rm memcached.tgz && \
        mv /usr/src/php/ext/memcached-3.0.3 /usr/src/php/ext/memcached

# set recommended PHP.ini settings
# see https://secure.php.net/manual/en/opcache.installation.php
RUN { \
        echo 'opcache.memory_consumption=128'; \
        echo 'opcache.interned_strings_buffer=8'; \
        echo 'opcache.max_accelerated_files=4000'; \
        echo 'opcache.revalidate_freq=2'; \
        echo 'opcache.fast_shutdown=1'; \
        echo 'opcache.enable_cli=1'; \
    } > /usr/local/etc/php/conf.d/opcache-recommended.ini


# Install needed php extensions: memcache
#
RUN apt-get install --no-install-recommends -y unzip libssl-dev libpcre3 libpcre3-dev && \
    cd /usr/src/php/ext/ && \
    curl -sSL -o php7.zip https://github.com/websupport-sk/pecl-memcache/archive/NON_BLOCKING_IO_php7.zip && \
    unzip php7.zip && \
    mv pecl-memcache-NON_BLOCKING_IO_php7 memcache && \
    docker-php-ext-configure memcache --with-php-config=/usr/local/bin/php-config && \
    docker-php-ext-install memcache && \
    echo "extension=memcache.so" > /usr/local/etc/php/conf.d/ext-memcache.ini && \
    rm -rf /tmp/pecl-memcache-php7 php7.zip


# Install needed php extensions: zip
#
RUN apt-get install -y libz-dev && \
    curl -o zip.tgz -SL http://pecl.php.net/get/zip-1.15.1.tgz && \
        tar -xf zip.tgz -C /usr/src/php/ext/ && \
        rm zip.tgz && \
        mv /usr/src/php/ext/zip-1.15.1 /usr/src/php/ext/zip

RUN docker-php-ext-install memcached
RUN docker-php-ext-install memcache
RUN docker-php-ext-install zip


# COPY --chown=www-data:www-data /home/petert/docker/wordpress/storefront-child /usr/src/wordpress/wp-content/themes

# This is not used, so removed.
# Install needed php extensions: ldap
#
# RUN apt-get install libldap2-dev -y && \
#     docker-php-ext-configure ldap --with-libdir=lib/x86_64-linux-gnu/ && \
#     docker-php-ext-install ldap

## Don't need this installed locally within the container as commands can be run with exec-wp.sh
# RUN set -ex \
#     && curl --retry 7 --fail -Ls -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
#     && chmod +x wp-cli.phar \
#     && mv wp-cli.phar /usr/local/bin/wp-cli \
#     && wp --info --allow-root

# Install needed wordpress extensions: WP-FFPC
#
RUN cd /usr/src/wordpress/wp-content/plugins && \
    curl -o wp-ffpc.zip -L https://downloads.wordpress.org/plugin/wp-ffpc.zip && \
    unzip -o wp-ffpc.zip && \
    chown -R www-data:www-data wp-ffpc && \
    rm -f wp-ffpc.zip

# Enable Wordpress Caching
RUN cd /usr/src/wordpress && ls -l && \
    sed -ri -e "s#(<\?php)#\\1\ndefine('WP_CACHE', 'true');#g" wp-config-sample.php

# Cleanup
RUN rm -rf /var/lib/apt/lists/*


# ENTRYPOINT resets CMD
ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["php-fpm"]
