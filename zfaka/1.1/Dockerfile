FROM qiudong19901008/php:1.0

# 设置是否开启opcache缓存, 0表示不开启, 1表示开启
ENV OPCACHE_ENABLE=1

# 配置apk包国内地址, 下载慢就开启. 不过开启了还是慢, 最好用vpn
# RUN echo 'https://mirrors.aliyun.com/alpine/v3.9/main/' > /etc/apk/repositories && \
#     echo 'https://mirrors.aliyun.com/alpine/v3.9/community/' >> /etc/apk/repositories

# 安装yaf
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

# 1.1 新增, 有时候需要修改uid和gid, 而国内服务器很慢
# 所以预先在镜像内安装, 可以直接使用修改命令
RUN apk --no-cache add shadow






