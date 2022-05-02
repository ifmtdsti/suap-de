#!/bin/bash

#

if [ ! -x "$(command -v docker)" ]; then

    echo "ERRO: Você precisa instalar o docker"

fi

#

if [ ! -x "$(command -v docker-compose)" ]; then

    echo "ERRO: Você precisa instalar o docker-compose"

fi

#

if [ ! -x "$(command -v sshpass)" ]; then

    echo "ERRO: Você precisa instalar o sshpass"

fi

#

if [ ! -f "${HOME}/.ssh/id_rsa" ] ; then

    echo "ERRO: Você precisa criar chave SSH"
    exit 1

fi

#

if [ ! -d "../suap" ] ; then

    git clone git@gitlab.ifmt.edu.br:csn/suap.git ../suap

fi

if [ ! -d "../cron" ] ; then

    git clone git@gitlab.ifmt.edu.br:csn/suap-de-cron.git ../cron

fi

if [ ! -d "../safe" ] ; then

    git clone git@gitlab.ifmt.edu.br:csn/suap-de-safe.git ../safe

fi

#

mkdir -p ${PWD}/lib/ssh/
mkdir -p ${PWD}/var/con/
mkdir -p ${PWD}/var/loc/

#

if [ ! -f ".env-dba" ] ; then

    cp ${PWD}/lib/env/dba.txt ${PWD}/.env-dba

fi

if [ ! -f ".env-red" ] ; then

    cp ${PWD}/lib/env/red.txt ${PWD}/.env-red

fi

if [ ! -f ".env-sql" ] ; then

    cp ${PWD}/lib/env/sql.txt ${PWD}/.env-sql

fi

#

install -m 600 ${HOME}/.ssh/id_rsa     ${PWD}/lib/ssh/id_rsa
install -m 600 ${HOME}/.ssh/id_rsa.pub ${PWD}/lib/ssh/id_rsa.pub
install -m 600 ${HOME}/.ssh/id_rsa.pub ${PWD}/lib/ssh/authorized_keys

#

mkdir -p ../suap/.local/bin

install -m 755 ${PWD}/lib/bin/start-gunicorn.sh ../suap/.local/bin/start-gunicorn.sh
install -m 755 ${PWD}/lib/bin/stop-gunicorn.sh  ../suap/.local/bin/stop-gunicorn.sh

#

if [ ! -f .env ] ; then

    echo "BASE=${HOME}/.opt/suap" > .env

fi

#

. .env

if [ ! -d "${BASE}" ] ; then

    sudo mkdir -p ${BASE}/{dba,red,sql}

    sudo chmod -R 775 $BASE

    sudo chown 5050:5050 ${BASE}/dba

fi

#

ssh-keygen -f "${HOME}/.ssh/known_hosts" -R "[localhost]:8022" >/dev/null 2>&1
