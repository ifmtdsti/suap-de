#!/bin/bash

if [ "${HOSTNAME}" != "app" ] ; then

    exit 0

fi

set -e

PID_FILE=/tmp/suap.pid

if [ ! -f ${PID_FILE} ] ; then

    echo "gunicorn não esta sendo executado"

fi

pkill -F ${PID_FILE}

rm -fr ${PID_FILE}
