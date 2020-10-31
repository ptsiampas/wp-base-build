FROM wordpress:5.5.1-php7.4-fpm

LABEL maintainer='Peter Tsiampas <peter@tsiampas.com>'

RUN apt-get update
RUN apt-get install --no-install-recommends -y tidy csstidy nano netcat

RUN mkdir -p /usr/src/php/ext

RUN apt-get install -y libz-dev libmemcached-dev libzip-dev zip && \
    pecl install memcached && \
    docker-php-ext-enable memcached
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

# Install needed php extensions: zip
#
RUN apt-get install -y libz-dev && \
    curl -o zip.tgz -SL http://pecl.php.net/get/zip-1.15.1.tgz && \
        tar -xf zip.tgz -C /usr/src/php/ext/ && \
        rm zip.tgz && \
        mv /usr/src/php/ext/zip-1.15.1 /usr/src/php/ext/zip

RUN docker-php-ext-install zip

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
