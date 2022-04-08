#!/bin/bash

set -e

if [ "$HOSTNAME" != "app" ] ; then
    exit 0
fi

PID_FILE=/tmp/suap.pid

if [ ! -f $PID_FILE ] ; then
    echo "gunicorn não esta esta sendo executado"
    exit 0
fi

pkill -F $PID_FILE

rm -fr $PID_FILE
