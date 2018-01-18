#!/bin/sh

mkdir -p /var/www/html/yoursourcecodefoldername/tmp/cache
mkdir -p /var/www/html/yoursourcecodefoldername/tmp/html
chmod 777 -R /var/www/html/yoursourcecodefoldername/tmp

service redis_6379 start
exec "$@"
