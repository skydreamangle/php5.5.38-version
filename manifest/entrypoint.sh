#!/bin/sh

mkdir -p /var/www/html/gamma/daf/tmp/cache
mkdir -p /var/www/html/gamma/daf/tmp/html
chmod 777 -R /var/www/html/gamma/daf/tmp

service redis_6379 start
exec "$@"