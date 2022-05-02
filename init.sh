#!/bin/bash

#

if [ ! -x "$(command -v docker)" ]; then

    echo "ERRO: Você precisa instalar o docker"

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
mkdir -p ${PWD}/vol/con/
mkdir -p ${PWD}/vol/loc/

#

#

if [ ! -f ".env-dba" ] ; then

    cp ${PWD}/lib/env/dba.txt .env-dba

fi

if [ ! -f ".env-red" ] ; then

    cp ${PWD}/lib/env/red.txt .env-red

fi

if [ ! -f ".env-sql" ] ; then

    cp ${PWD}/lib/env/sql.txt .env-sql

fi

#

cp ${HOME}/.ssh/id_rsa     ${PWD}/lib/ssh/id_rsa
cp ${HOME}/.ssh/id_rsa.pub ${PWD}/lib/ssh/id_rsa.pub
cp ${HOME}/.ssh/id_rsa.pub ${PWD}/lib/ssh/authorized_keys

#

install -D ${PWD}/lib/start-gunicorn.sh ../suap/.local/bin/start-gunicorn.sh
install -D ${PWD}/lib/stop-gunicorn.sh  ../suap/.local/bin/stop-gunicorn.sh

#

if [ ! -f .env ] ; then

    echo "BASE=${HOME}/.opt/suap" > .env

fi

. .env

if [ ! -d "${BASE}" ] ; then

    mkdir ${BASE}

fi

ssh-keygen -f "${HOME}/.ssh/known_hosts" -R "[localhost]:8022" >/dev/null 2>&1
