#!/bin/bash

set -e

if [ "$HOSTNAME" != "app" ] ; then
    exit 0
fi

PID_FILE=/tmp/suap.pid

if [ -f $PID_FILE ] ; then
    echo "gunicorn já esta sendo executado"
    exit 0
fi

LOG_FILE=deploy/logs/gunicorn/gunicorn.log

LOG_DIR=$(dirname $LOG_FILE)

test -d $LOG_DIR || mkdir -p $LOG_DIR

WORKERS=$(($(nproc)*2+1))

gunicorn suap.wsgi:application --bind=0.0.0.0:8000 --workers=$WORKERS --timeout=1800 --pid=$PID_FILE --log-file=$LOG_FILE --daemon >> $LOG_FILE
