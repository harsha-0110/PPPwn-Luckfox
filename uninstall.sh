#!/bin/sh

WEB_DIR=/var/www/pppwn
TARGET_DIR=/etc/pppwn

kill -9 `pidof pppoe pppoe-server php-fpm nginx pppwn1 pppwn2 pppwn3 web_monitor.sh S99pppwn-service` > /dev/null 2>&1
rm -rf $WEB_DIR > /dev/null 2>&1
cp -p /etc/nginx/nginx.conf.default /etc/nginx/nginx.conf > /dev/null 2>&1
find $TARGET_DIR ! -name "*config*" -exec rm -f {} + > /dev/null 2>&1
if [ -f $TARGET_DIR/config.json ]; then
    mv $TARGET_DIR/config.json $TARGET_DIR/config.json.bak
    sed -e 's/[{}]//g' -e 's/"//g' -e 's/:\s/=/g' -e 's/,//g' -e '/^\s*$/d' -e 's/^\s*//' $TARGET_DIR/config.json.bak > $TARGET_DIR/config.ini 2> /dev/null
fi
find /etc/ppp -type f ! -name "pppoe.conf" ! -name "radius" -exec rm -f {} +