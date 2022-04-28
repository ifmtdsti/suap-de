#!/bin/bash

if [ "$HOSTNAME" != "app" ] ; then
    exit 0
fi

PID_FILE=/tmp/suap.pid

if [ -f $PID_FILE ] ; then

    pkill -F $PID_FILE

    rm -fr $PID_FILE

else

    echo "gunicorn não esta sendo executado"

fi
