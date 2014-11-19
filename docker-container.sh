#!/bin/sh
if [ "$2" = "" ];then
	echo "Input parametor FQDN and HTTP-PORT"
else
	__FQDN__=$1
	__PORT__=$2
	__HOSTNAME__=`echo $__FQDN__ | sed -r "s/\./_/g"`
	FULLPATH=$(cd `dirname $0`; pwd)/`basename $0`
	DIR=`dirname $FULLPATH`
	TAG=`basename $DIR`
	DOCKER_IMAGE=typista/docker:$TAG
	docker run -d --name="$__FQDN__" --hostname="$__HOSTNAME__" -p $__PORT__:80 -v /var/www/:/var/www/ -v /var/log/nginx/:/var/log/nginx/ $DOCKER_IMAGE
fi

