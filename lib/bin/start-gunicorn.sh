#!/bin/bash

set -e

if [ "${HOSTNAME}" != "app" ] ; then

    echo "script só pode ser dentro do container"
    exit 1

fi

PID_FILE=/tmp/suap.pid

if [ -f ${PID_FILE} ] ; then

    echo "gunicorn já esta sendo executado"
    exit 1

fi

LOG_FILE=/app/suap/deploy/logs/gunicorn/gunicorn.log

LOG_DIR=$(dirname ${LOG_FILE})

test -d ${LOG_DIR} || mkdir -p ${LOG_DIR}

WORKERS=$(($(nproc)+1))

gunicorn suap.wsgi:application -b 0.0.0.0:8000 -w ${WORKERS} -t 360 --pid=${PID_FILE} --capture-output --log-level=critical --log-file=${LOG_FILE} --daemon
