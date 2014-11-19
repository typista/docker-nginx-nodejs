#!/bin/sh
FULLPATH=$(cd `dirname $0`; pwd)/`basename $0`
DIR=`dirname $FULLPATH`
TAG=`basename $DIR`
docker rmi typista/docker:$TAG

