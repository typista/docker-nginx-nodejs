#!/bin/bash
HOSTNAME=`hostname`
FQDN=`echo $HOSTNAME | sed -r "s/_/\./g"`
ROOT=/var/www/$HOSTNAME
HTML=$ROOT/html
if [ ! -e $HTML ]; then
	mkdir -p $HTML
	wget $GIT_URL/package.json -O $HTML/package.json
	wget $GIT_URL/app.js -O $HTML/app.js
    cd $HTML
    npm install
fi
APP=index.js
if [ -f $HTML/app.js ]; then
	APP=app.js
fi
/usr/bin/forever start $APP
LINK=/usr/share/nginx/html
if [ ! -L $LINK ]; then
	rm -rf $LINK
	ln -s $HTML $LINK
fi
chown -R nginx: $ROOT

NGINX_BIN=/etc/init.d/nginx
if [ ! -f $NGINX_BIN ]; then
	wget $URL_GIT/etc_init.d_nginx -O $NGINX_BIN 
	chmod +x $NGINX_BIN
fi

# mount:/var/log/nginx
LOG=/var/log/nginx/$HOSTNAME
NGINX=/usr/local/nginx
if [ ! -e $LOG ]; then
	mkdir -p $LOG
fi
NGINX_CONF=$NGINX/conf/nginx.conf
NGINX_CONF_TEMP=/root/export/nginx.conf
if [ ! -f $NGINX_CONF_TEMP ];then
	wget $URL_GIT/nginx.conf -O $NGINX_CONF_TEMP
	cp $NGINX_CONF_TEMP $NGINX_CONF
fi
PROCNUM=`grep processor /proc/cpuinfo | wc -l`
ISDEFAULT=`grep $HOSTNAME $NGINX_CONF | wc -l`
if [ $ISDEFAULT -eq 0 ]; then
	sed -ri "s/__PROCNUM__/$PROCNUM/g" $NGINX_CONF
	sed -ri "s/__HOSTNAME__/$HOSTNAME/g" $NGINX_CONF
	sed -ri "s/__FQDN__/$FQDN/g" $NGINX_CONF
fi
CRON_SHELL=/root/export/start.sh
if [ ! -f $CRON_SHELL ]; then
	wget $URL_GIT/start.sh -O $CRON_SHELL
fi
if [ ! -x $CRON_SHELL ]; then
	chmod +x $CRON_SHELL
fi
MONITOR_NGINX=/root/export/monitor_nginx.sh
if [ ! -f $MONITOR_NGINX ]; then
	wget $URL_GIT/monitor_nginx.sh -O $MONITOR_NGINX
	echo $MONITOR_NGINX >> $CRON_SHELL
fi
if [ ! -x $MONITOR_NGINX ]; then
	chmod +x $MONITOR_NGINX
fi
MONITOR_NODE=/root/export/monitor_node.sh
if [ ! -f $MONITOR_NODE ]; then
	wget $URL_GIT/monitor_node.sh -O $MONITOR_NODE
	echo $MONITOR_NODE >> $CRON_SHELL
fi
if [ ! -x $MONITOR_NODE ]; then
	chmod +x $MONITOR_NODE
fi
CRON_TAB=/root/export/crontab.txt
if [ ! -f $CRON_TAB ];then
	wget $URL_GIT/crontab.txt -O $CRON_TAB
fi

chown -R nginx: $LOG
crontab $CRON_TAB
