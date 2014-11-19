#!/bin/bash
# mount:/var/www
HOSTNAME=`hostname`
ROOT=/var/www/$HOSTNAME
HTML=$ROOT/html
if [ ! -e $HTML ]; then
	mkdir -p $HTML
	cp /tmp/package.json $HTML/
	cd $HTML
	cp /tmp/app.js $HTML/
	npm install
	/usr/bin/forever start app.js
fi
chown -R nginx: $ROOT

# mount:/var/log/nginx
LOG=/var/log/nginx/$HOSTNAME
if [ ! -e $LOG ]; then
	mkdir -p $LOG
fi
NGINX_CONF=/usr/local/nginx/conf/nginx.conf
ISDEFAULT=`grep $HOSTNAME $NGINX_CONF | wc -l`
if [ $ISDEFAULT -eq 0 ]; then
	sed -ri "s/__HOSTNAME__/$HOSTNAME/g" $NGINX_CONF
fi
chown -R nginx: $LOG

/etc/init.d/php-fastcgi start
#/usr/local/nginx/sbin/nginx -g "daemon off;"
/etc/init.d/nginx start
/usr/bin/tail -f /dev/null
