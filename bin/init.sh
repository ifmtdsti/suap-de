#!/bin/bash

DIR1="../suap"
DIR2="../cron"
DIR3="../safe"

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

if [ ! -d "${DIR1}" ] ; then

    git clone git@gitlab.ifmt.edu.br:csn/suap.git ${DIR1}

fi

if [ ! -d "${DIR2}" ] ; then

    git clone git@gitlab.ifmt.edu.br:csn/suap-de-cron.git ${DIR2}

fi

if [ ! -d "${DIR3}" ] ; then

    git clone git@gitlab.ifmt.edu.br:csn/suap-de-safe.git ${DIR3}

fi

#

mkdir -p ${PWD}/var/con/
mkdir -p ${PWD}/var/loc/
mkdir -p ${PWD}/var/ssh/

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

install -m 600 ${HOME}/.ssh/id_rsa     ${PWD}/var/ssh/id_rsa
install -m 600 ${HOME}/.ssh/id_rsa.pub ${PWD}/var/ssh/id_rsa.pub
install -m 600 ${HOME}/.ssh/id_rsa.pub ${PWD}/var/ssh/authorized_keys

#

mkdir -p ${DIR1}/.local/bin

install -m 755 ${PWD}/lib/bin/start-gunicorn.sh ${DIR1}/.local/bin/start-gunicorn.sh
install -m 755 ${PWD}/lib/bin/stop-gunicorn.sh  ${DIR1}/.local/bin/stop-gunicorn.sh
install -m 755 ${PWD}/lib/bin/install-pip.sh    ${DIR1}/.local/bin/install-pip.sh
install -m 755 ${PWD}/lib/bin/uninstall-pip.sh  ${DIR1}/.local/bin/uninstall-pip.sh
install -m 755 ${PWD}/lib/bin/synchronize.sh    ${DIR1}/.local/bin/synchronize.sh

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
