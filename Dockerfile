From amazonlinux

MAINTAINER shuying <shuying@movarkstyle.com>

RUN yum update -y && yum upgrade -y
RUN cp /usr/share/zoneinfo/Asia/Taipei /etc/localtime

# create folder
RUN mkdir -p /etc/php-fpm.d
RUN mkdir -p /usr/lib/php/modules
RUN mkdir -p /var/www/html

RUN yum install -y htop wget vim git curl tar make autoconf gcc g++ sed unzip nginx
RUN yum install -y zlib-devel libressl-devel pcre-devel fcgi-devel jpeg-devel libmcrypt-devel bzip2-devel curl-devel libpng-devel libxslt-devel postgresql-devel perl-devel file acl-devel libedit-devel libxml2 libxml2-devel freetype-devel libpng-devel gd-devel libcurl-devel libxslt libxslt-devel pcre pcre-devel openssl openssl-devel libmcrypt libmcrypt-devel mcrypt mhash mhash-devel libjpeg libjpeg-devel libpng libpng-devel libmemcached libmemcached-devel libsasl cyrus-sasl-devel 

# php-fpm-5.5.38
RUN cd /tmp && wget http://de2.php.net/get/php-5.5.38.tar.gz/from/this/mirror -O php-5.5.38.tar.gz
RUN tar -zxvf /tmp/php-5.5.38.tar.gz && \
    cd php-5.5.38 && \
    ./configure --prefix=/usr --with-config-file-path=/etc --with-config-file-scan-dir=/etc/php-fpm.d --with-mysql=mysqlnd --with-iconv-dir=/usr/local/libiconv --disable-cgi --enable-mbstring --enable-mysqlnd --enable-soap --enable-calendar --enable-inline-optimization --enable-sockets --enable-sysvmsg --enable-sysvsem --enable-sysvshm --enable-pcntl --enable-mbregex --enable-exif --enable-bcmath --enable-zip --enable-ftp --enable-opcache --enable-fpm --enable-gd-native-ttf --enable-xml --enable-xmlreader --enable-xmlwriter --with-mysql --with-pdo_mysql --with-pdo_sqlite --with-libedit --with-libxml-dir=/usr --with-curl --with-mcrypt --with-zlib --with-gd --with-pgsql --with-bz2 --with-zlib --with-mhash --with-mcrypt --with-pcre-regex --with-pdo-mysql --with-jpeg-dir=/usr --with-png-dir=/usr --with-openssl --with-libdir=/usr/lib --with-gettext --with-xmlrpc --with-xsl --with-pear --with-mysqli && make && make install && \
    cp sapi/fpm/init.d.php-fpm /etc/init.d/php-fpm && \
    cp php.ini-production /usr/etc/php.ini 
RUN ln -s /usr/lib/php/extensions/no-debug-non-zts-20121212/opcache.so /usr/lib/php/modules/opcache.so
RUN yum install -y php55-common php55-cli php55-process php55-xml
RUN yum install -y php55-pecl-memcache
RUN cp /usr/lib64/php/5.5/modules/memcache.so /usr/lib/php/modules/memcache.so
RUN cp /usr/lib64/php/5.5/modules/memcache.so /usr/lib/php/extensions/no-debug-non-zts-20121212/memcache.so
RUN cp /etc/php-5.5.d/memcache.ini /etc/php-fpm.d/memcache.ini
RUN yum install -y php55-pecl-memcached 
RUN cp /usr/lib64/php/5.5/modules/memcached.so /usr/lib/php/modules/memcached.so 
RUN cp /usr/lib64/php/5.5/modules/memcached.so /usr/lib/php/extensions/no-debug-non-zts-20121212/memcached.so 
RUN cp /etc/php-5.5.d/memcached.ini /etc/php-fpm.d/memcached.ini
RUN cd /tmp && wget https://github.com/phalcon/cphalcon/archive/v1.2.4.zip
RUN unzip /tmp/v1.2.4.zip && cd cphalcon-1.2.4/build && ./install
RUN sh -c "echo 'extension=phalcon.so' >> /etc/php-fpm.d/phalcon.ini" 
RUN yum install -y php55-pecl-redis
RUN cp /usr/lib64/php/5.5/modules/redis.so /usr/lib/php/modules/redis.so
RUN cp /usr/lib64/php/5.5/modules/redis.so /usr/lib/php/extensions/no-debug-non-zts-20121212/redis.so
RUN cp /etc/php-5.5.d/redis.ini /etc/php-fpm.d/redis.ini
ADD manifest/etc/php/opcache.ini /etc/php-fpm.d/opcache.ini
COPY manifest/etc/php/php.ini /etc/alternatives/php.ini
COPY manifest/etc/nginx/conf.d /etc/nginx/conf.d
COPY manifest/etc/nginx/nginx.conf /etc/nginx/nginx.conf

RUN cp /usr/etc/php-fpm.conf.default /usr/etc/php-fpm.conf
RUN chmod +x /etc/init.d/php-fpm
RUN touch /etc/sysconfig/network

RUN cd /tmp && \
    wget http://download.redis.io/redis-stable.tar.gz && \
    tar xzvf redis-stable.tar.gz && \
    cd redis-stable && \
    make && \
    make install
RUN cd /tmp/redis-stable/utils && ./install_server.sh

RUN mkdir -p /var/www/html/gamma/daf
COPY ./daf /var/www/html/gamma/daf

WORKDIR /var/www/html/gamma/daf

COPY ./manifest/config/gamma_config.ini /var/www/html/gamma/daf/app/config/gamma_config.ini
COPY ./manifest/config/production_config.ini /var/www/html/gamma/daf/app/config/production_config.ini

COPY manifest/entrypoint.sh /entrypoint.sh
RUN chmod 0755 /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

RUN chkconfig nginx on
RUN chkconfig php-fpm on
RUN chkconfig redis_6379 on

EXPOSE 80

CMD php-fpm -d variables_order="EGPCS" && (tail -F /var/log/nginx/access.log &) && exec nginx -g "daemon off;" && redis_6379
