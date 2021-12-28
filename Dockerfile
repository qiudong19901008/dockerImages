FROM qiudong19901008/php:1.1

# 设置是否开启opcache缓存, 0表示不开启, 1表示开启
ENV OPCACHE_ENABLE=1

# pecl安装yaf扩展
RUN apk add --no-cache $PHPIZE_DEPS \
    && apk update \
    && pecl install yaf-3.0.8 \
    && apk del $PHPIZE_DEPS

# 配置php.ini
COPY ./conf.d/ $PHP_INI_DIR/conf.d/

# 配置www.conf
COPY ./www.conf $WWW_CONF_PATH

# 安装zfaka程序
ADD ./zfaka-1.4.4.tar.gz /var/www/
RUN mv /var/www/zfaka-1.4.4/* /var/www/html/ \
    && chown -R www-data:www-data /var/www/html \
    && rm -rf /var/www/zfaka-1.4.4







