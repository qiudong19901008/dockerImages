# BEGIN

FROM php:8.1.2-fpm-alpine3.15
# 设置容器时区, 世界时间+8
ENV TZ="Asia/Shanghai"
# 设置是否开启opcache缓存, 0表示不开启, 1表示开启
ENV OPCACHE_ENABLE=0
# php-fpm.conf www.conf 配置路径
ENV PHP_FPM_PATH="/usr/local/etc/php-fpm.conf"
ENV WWW_CONF_PATH="/usr/local/etc/php-fpm.d/www.conf"

# 配置apk包国内地址, 下载慢就开启. 不过开启了还是慢, 最好用vpn
# RUN echo 'https://mirrors.aliyun.com/alpine/v3.9/main/' > /etc/apk/repositories && \
#     echo 'https://mirrors.aliyun.com/alpine/v3.9/community/' >> /etc/apk/repositories

# 安装内置扩展 gd pdo_mysql opcache mbstring
RUN apk add --no-cache freetype libpng libjpeg-turbo freetype-dev libpng-dev libjpeg-turbo-dev \
    && apk update \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ --with-png-dir=/usr/include/ \
    && docker-php-ext-install -j$(nproc) gd pdo_mysql opcache mbstring bcmath

# 安装PECL扩展 redis
RUN apk add --no-cache $PHPIZE_DEPS \
    && apk update \
    && pecl install redis-4.3.0 \
    && docker-php-ext-enable redis \
    && apk del $PHPIZE_DEPS

# 获取php.ini
RUN cp "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini"

# 配置php.ini, 配置了opcache, timezone
COPY ./conf.d/ $PHP_INI_DIR/conf.d/

# 配置php-fpm.conf
RUN sed 's/;emergency_restart_threshold.*/emergency_restart_threshold = 10/' $PHP_FPM_PATH \
    && sed 's/;emergency_restart_interval.*/emergency_restart_interval = 1m/' $PHP_FPM_PATH \
    && sed 's/;process_control_timeout.*/process_control_timeout = 10s/' $PHP_FPM_PATH

# 设置www.conf的默认配置
COPY ./www.conf $WWW_CONF_PATH

# 添加修改uid,gid和时区的工具
RUN apk --no-cache add shadow tzdata

# END


# 大家以这个镜像构建时, 有两个变量能用:
# OPCACHE_ENABLE, 0不开启opcache, 1开启opcache
# WWW_CONF_PATH, www.conf的路径, 用来被你的配置覆盖, 不覆盖则使用默认




