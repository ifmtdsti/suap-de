#!/bin/bash

set -e

DIR1="../suap"
DIR2="../cron"
DIR3="../safe"

#

if [ ! -x "$(command -v docker)" ]; then

    echo "ERRO: Você precisa instalar o docker"
    exit 1

fi

#

if [ ! -x "$(command -v docker-compose)" ]; then

    echo "ERRO: Você precisa instalar o docker-compose"
    exit 1

fi

#

if [ ! -x "$(command -v sshpass)" ]; then

    echo "ERRO: Você precisa instalar o sshpass"
    exit 1

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

if [ ! -f .env ] ; then

    echo "BASE=${HOME}/.opt/suap" > .env

fi

#

. .env

#

if [ ! -d "${BASE}" ] ; then

    sudo mkdir -p ${BASE}/{dba,moo,red,sql}

    sudo chmod -R 775 $BASE

    sudo chown 5050:5050 ${BASE}/dba

fi

#

mkdir -p ${PWD}/var/con/
mkdir -p ${PWD}/var/loc/share/code-server/User/
mkdir -p ${PWD}/var/ssh/

#

if [ ! -f ".env-app" ] ; then

    cp ${PWD}/lib/etc/-app.txt ${PWD}/.env-app

fi

if [ ! -f ".env-dba" ] ; then

    cp ${PWD}/lib/etc/-dba.txt ${PWD}/.env-dba

fi

if [ ! -f ".env-moo" ] ; then

    cp ${PWD}/lib/etc/-moo.txt ${PWD}/.env-moo

fi

if [ ! -f ".env-red" ] ; then

    cp ${PWD}/lib/etc/-red.txt ${PWD}/.env-red

fi

if [ ! -f ".env-sql" ] ; then

    cp ${PWD}/lib/etc/-sql.txt ${PWD}/.env-sql

fi

#

mkdir -p ${DIR1}/.local/bin

install -m 755 ${PWD}/lib/bin/install-pip.sh    ${DIR1}/.local/bin/install-pip.sh
install -m 755 ${PWD}/lib/bin/install-vcext.sh  ${DIR1}/.local/bin/install-vcext.sh
install -m 755 ${PWD}/lib/bin/start-gunicorn.sh ${DIR1}/.local/bin/start-gunicorn.sh
install -m 755 ${PWD}/lib/bin/stop-gunicorn.sh  ${DIR1}/.local/bin/stop-gunicorn.sh
install -m 755 ${PWD}/lib/bin/synchronize.sh    ${DIR1}/.local/bin/synchronize.sh
install -m 755 ${PWD}/lib/bin/uninstall-pip.sh  ${DIR1}/.local/bin/uninstall-pip.sh

#

mkdir -p ${DIR1}/.vscode

J1="${PWD}/lib/etc/launch.txt"
J2="${DIR1}/.vscode/launch.json"

if [ ! -f "${J2}" ] ; then

    install -m 644 ${J1} ${J2}

fi

#

J1="${PWD}/lib/etc/settings.txt"
J2="${PWD}/var/loc/share/code-server/User/settings.json"

if [ ! -f "${J2}" ] ; then

    install -m 644 ${J1} ${J2}

fi

#

install -m 600 ${HOME}/.ssh/id_rsa     ${PWD}/var/ssh/id_rsa
install -m 600 ${HOME}/.ssh/id_rsa.pub ${PWD}/var/ssh/id_rsa.pub
install -m 600 ${HOME}/.ssh/id_rsa.pub ${PWD}/var/ssh/authorized_keys

#

ssh-keygen -f "${HOME}/.ssh/known_hosts" -R "[localhost]:8022" >/dev/null 2>&1
