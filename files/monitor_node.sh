#!/bin/sh
BIN=/usr/bin/forever
HTML=/var/www/`hostname`/html
APP=index.js
if [ -f $HTML/app.js ]; then
    APP=app.js
fi
IS_EXEC=`cat $MONITOR_PS_LIST | grep -v 'null' | grep '/usr/bin/node /usr/lib/node_modules/forever/bin/monitor'`
if [ -f $BIN -a "$IS_EXEC" = "" ];then
	cd $HTML
    $BIN start $APP
fi

