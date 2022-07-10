#!/bin/bash

set -e

if [ "${HOSTNAME}" != "app" ] ; then

    echo "script só pode ser dentro do container"
    exit 1

fi

PID_FILE=/app/suap/deploy/media/tmp/suap.pid

if [ ! -f ${PID_FILE} ] ; then

    echo "gunicorn não esta sendo executado"
    exit 1

fi

pkill -F ${PID_FILE}

rm -fr ${PID_FILE}
