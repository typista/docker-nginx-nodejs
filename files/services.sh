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
fi
APP=app.js
if [ -f $HTML/index.js ]; then
	APP=index.js
fi
/usr/bin/forever start $APP
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
crontab /root/crontab.txt
/etc/init.d/nginx start
/etc/init.d/crond start
/usr/bin/tail -f /dev/null
