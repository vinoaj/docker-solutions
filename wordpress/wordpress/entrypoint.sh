#!/bin/sh
cd /var/www/html

wp --info
wp --allow-root option update home 'https://measurementcookbook.com'
wp --allow-root option update siteurl 'https://measurementcookbook.com'

exec "$@"