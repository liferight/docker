# Build:
# docker build --build-arg DOMAIN=app.domain.com --build-arg NGINX=1.10.3 --build-arg PHP=7.0.17 -t zokeber/pfn:latest .
#
# Create:
# docker create -it -p 80:80 --restart=always --name php7-fpm-nginx -h php7-fpm-nginx zokeber/pfn
#
# Start:
# docker start php7fpm-nginx
#
# Connect with bash:
# docker exec -it php7fpm-nginx bash


# Pull base image of CentOS 7 (Zokeber Images)
FROM centos:latest

# Maintener
LABEL maintener "Daniel Lopez Monagas <zokeber@gmail.com>"
LABEL version "0.0.1"
LABEL description "PHP + PHP-FPM + Nginx (compile from sources) in CentOS 7 image"

# Install essential packages for this dockerfile
RUN yum install wget curl git epel-release vim yum-utils -y

# Update
RUN yum update -y && \
	yum upgrade -y && \
	yum clean all

# Environments Variable
ARG NGINX
ARG PHP
ARG DOMAIN
ENV VIRTUALHOST=$DOMAIN
ENV DIR_VIRTUALHOST=/var/www/html
ENV PATH_COMPILE=/opt
ENV PHP_VERSION=$PHP
ENV PHP_TMP=/opt/php
ENV PHP_PATH=/etc/php
ENV NGINX_VERSION=$NGINX
ENV USER_NGINX=nginx
ENV NGINX_TMP=/opt/nginx

# Install packages for compile php and nginx
RUN yum update -y && \
    yum install tar net-tools bzip2 hostname rsyslog gc gcc gcc-c++ pcre-devel zlib-devel make wget openssl-devel libxml2-devel libxslt-devel gd-devel perl-ExtUtils-Embed GeoIP-devel gperftools gperftools-devel libatomic_ops-devel perl-ExtUtils-Embed cryptsetup-devel cryptsetup unzip git libxml2-devel pkgconfig openssl-devel bzip2-devel curl-devel libpng-devel libjpeg-devel libXpm-devel freetype-devel gmp-devel libmcrypt-devel mariadb-devel aspell-devel recode-devel libpqxx-devel autoconf bison \
    re2c libicu-devel libwebp-devel libc-client-devel libpng12-devel libxslt-devel libssh2-devel libssh2 -y

# Install NGINX
RUN mkdir -p "$NGINX_TMP" && \
    cd "$NGINX_TMP" && \
    wget -c http://nginx.org/download/nginx-$NGINX_VERSION.tar.gz && \
    tar xzf nginx-$NGINX_VERSION.tar.gz && \
    useradd -s /bin/false $USER_NGINX && \
    cd "$NGINX_TMP"/nginx-$NGINX_VERSION && \
    bash configure --prefix=/usr --sbin-path=/usr/sbin/nginx --conf-path=/etc/nginx/nginx.conf --error-log-path=/var/log/nginx/error.log --http-log-path=/var/log/nginx/access.log --http-client-body-temp-path=/var/lib/nginx/body --http-fastcgi-temp-path=/var/lib/nginx/fastcgi --http-proxy-temp-path=/var/lib/nginx/proxy --http-scgi-temp-path=/var/lib/nginx/scgi --http-uwsgi-temp-path=/var/lib/nginx/uwsgi --lock-path=/var/lock/nginx.lock --pid-path=/run/nginx/nginx.pid --user=$USER_NGINX --group=$USER_NGINX --with-ipv6 --with-http_v2_module --with-http_addition_module --with-http_dav_module --with-http_geoip_module --with-http_gzip_static_module --with-http_image_filter_module --with-http_realip_module --with-http_stub_status_module --with-http_ssl_module --with-http_sub_module --with-http_xslt_module --with-select_module --with-poll_module --with-file-aio --with-http_realip_module --with-http_addition_module --with-http_xslt_module --with-http_image_filter_module --with-http_sub_module --with-http_dav_module --with-http_flv_module --with-http_mp4_module --with-http_gunzip_module --with-http_gzip_static_module --with-http_auth_request_module --with-http_random_index_module --with-http_secure_link_module --with-http_degradation_module --with-http_stub_status_module --with-http_perl_module --with-mail --with-mail_ssl_module --with-cpp_test_module --with-cpu-opt=CPU --with-pcre --with-pcre-jit --with-md5-asm --with-sha1-asm --with-zlib-asm=CPU --with-libatomic --with-debug --with-ld-opt="-Wl,-E" && \
    make && \
    make install && \
    mkdir -p /var/lib/nginx && \
    mkdir -p $DIR_VIRTUALHOST && \
    chown -R $USER_NGINX:$USER_NGINX /var/lib/nginx && \
    chown -R $USER_NGINX:$USER_NGINX /etc/nginx && \
    chown -R $USER_NGINX:$USER_NGINX /var/log/nginx && \
    chown -R $USER_NGINX:$USER_NGINX $DIR_VIRTUALHOST && \
    mkdir -p /etc/nginx/{default.d,conf.d} && \
    rm -f /etc/nginx/*.default

# Install PHP and PHP-FPM
RUN mkdir -p "${PHP_TMP}" && \
    mkdir -p "${PHP_PATH}" && \
    mkdir -p "${PHP_PATH}".d/ && \
    cd "${PHP_TMP}" && \
    wget http://us1.php.net/distributions/php-$PHP_VERSION.tar.bz2 -O php-$PHP_VERSION.tar.bz2 && \
    tar jxf php-$PHP_VERSION.tar.bz2 && \
    cd php-$PHP_VERSION && \
    bash configure --prefix=/usr --sysconfdir="${PHP_PATH}" --with-config-file-path="${PHP_PATH}" --with-config-file-scan-dir=$PHP_PATH.d/ --with-pdo-pgsql --with-zlib-dir --with-freetype-dir --enable-mbstring --with-libxml-dir=/usr --enable-soap --enable-calendar --with-curl --with-mcrypt --with-zlib --with-gd --with-pgsql --disable-rpath --enable-inline-optimization --with-bz2 --with-zlib --enable-sockets --enable-sysvsem --enable-sysvshm --enable-pcntl --enable-mbregex --enable-exif --enable-bcmath --with-mhash --enable-zip --with-pcre-regex --with-pdo-mysql --with-mysqli --with-jpeg-dir=/usr --with-png-dir=/usr --enable-gd-native-ttf --with-openssl --with-fpm-user=$USER_NGINX --with-fpm-group=$USER_NGINX --with-libdir=/lib64/ --enable-ftp --with-imap --with-imap-ssl --with-kerberos --with-gettext --with-xmlrpc --with-xsl --with-ssh2=shared --enable-opcache --enable-fpm && \
    make && \
    make install && \
    mv "${PHP_TMP}"/php-$PHP_VERSION/php.ini-production "${PHP_PATH}"/php.ini && \
    mv "${PHP_PATH}"/php-fpm.conf.default "${PHP_PATH}"/php-fpm.conf && \
    mv "${PHP_PATH}"/php-fpm.d/www.conf.default "${PHP_PATH}"/php-fpm.d/www.conf 

# Copy default files
COPY conf/nginx.conf /etc/nginx/
COPY conf/default.conf /etc/nginx/conf.d/
COPY conf/start.sh /usr/local/bin/start.sh

# Copy yours project and information about php version
COPY project/index.html $DIR_VIRTUALHOST/
COPY project/info.php $DIR_VIRTUALHOST/

# Volumes and work directory
VOLUME ["/var/log", "/etc", "$DIR_VIRTUALHOST"]
WORKDIR $DIR_VIRTUALHOST

# Expose port 80
EXPOSE 80/tcp

# Script start.sh
CMD ["/usr/bin/bash", "/usr/local/bin/start.sh"]
