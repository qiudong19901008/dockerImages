FROM qiudong19901008/php8.1.2:1.0

# 设置是否开启opcache缓存, 0表示不开启, 1表示开启
ENV OPCACHE_ENABLE=1

# 配置php.ini
# COPY ./conf.d/ $PHP_INI_DIR/conf.d/

# 配置www.conf
COPY ./www.conf $WWW_CONF_PATH

# 安装zfaka程序
ADD ./acg-faka-0.7.3-beta.tar.gz /var/www/

RUN mv /var/www/acg-faka-0.7.3-beta/* /var/www/html/ \
    && chown -R www-data:www-data /var/www/html \
    && rm -rf /var/www/acg-faka-0.7.3-beta







