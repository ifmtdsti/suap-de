USER := suap

ifeq ($(OS), Windows_NT)
    SSH=ssh -p 8022 ${USER}@localhost
else
    SSH=sshpass -p${USER} ssh -p 8022 ${USER}@localhost
endif

all:

init: init-a init-b init-c init-d init-e init-f

start: clear-known-hosts start-compose

stop: stop-compose

restart: stop start

shell:

	@-${SSH}

init-a:

	@-if [ ! -d "../${USER}" ] ; then git clone git@gitlab.ifmt.edu.br:csn/${USER}.git ../${USER}; fi

init-b:

	@-if [ ! -d "../cron" ] ; then git clone git@gitlab.ifmt.edu.br:csn/${USER}-pc-cron.git ../cron; fi
	@-if [ ! -d "../safe" ] ; then git clone git@gitlab.ifmt.edu.br:csn/${USER}-pc-safe.git ../safe; fi

init-c:

	@-mkdir -p env/
	@-mkdir -p lib/
	@-mkdir -p lib/env/
	@-mkdir -p lib/git/
	@-mkdir -p lib/ssh/
	@-mkdir -p vcs/

init-d:

	@-if [ ! -f ".env-dba" ] ; then cp lib/env/dba.txt .env-dba; fi
	@-if [ ! -f ".env-git" ] ; then cp lib/env/git.txt .env-git; fi
	@-if [ ! -f ".env-red" ] ; then cp lib/env/red.txt .env-red; fi
	@-if [ ! -f ".env-sql" ] ; then cp lib/env/sql.txt .env-sql; fi

init-e:

	@-cp ${HOME}/.ssh/id_rsa     lib/ssh/id_rsa
	@-cp ${HOME}/.ssh/id_rsa.pub lib/ssh/id_rsa.pub
	@-cp ${HOME}/.ssh/id_rsa.pub lib/ssh/authorized_keys

init-f:

	@-install -D lib/start-gunicorn.sh ../${USER}/.local/bin/start-gunicorn.sh
	@-install -D lib/stop-gunicorn.sh  ../${USER}/.local/bin/stop-gunicorn.sh

clear-known-hosts:

	@-ssh-keygen -f "${HOME}/.ssh/known_hosts" -R "[localhost]:8022" >/dev/null 2>&1

start-compose: pull-docker

	@docker-compose --file compose.m.yml --file compose.o.yml up --remove-orphans --build --detach

stop-compose:

	@docker-compose --file compose.m.yml --file compose.o.yml down --remove-orphans --volumes

pull-docker:

	@docker pull ifmt/${USER}-os:latest

start-docker:

	@sudo service docker start

stop-docker:

	@sudo service docker stop

install-pip: install-pip-a install-pip-b install-pip-c

	@-${SSH} "bash -l -c 'python -m pip install -r requirements/custom.txt'"

install-pip-a:

	@-${SSH} "bash -l -c 'cd /opt/${USER}/app && python -m venv .env'"

install-pip-b:

	@-${SSH} "bash -l -c 'python -m pip install --upgrade pip'"

install-pip-c:

	@-${SSH} "bash -l -c 'python -m pip install wheel'"

uninstall-pip:

	@-${SSH} "bash -l -c 'cd /opt/${USER}/app && deactivate && rm -fr .env/*'"

manage-sync:

	@-${SSH} "bash -l -c 'python manage.py sync'"

manage-password:

	@-${SSH} "bash -l -c 'python manage.py set_passwords_to 123147'"

start-gunicorn:

	@-${SSH} "bash -l -c '.local/bin/start-gunicorn.sh'"

stop-gunicorn:

	@-${SSH} "bash -l -c '.local/bin/stop-gunicorn.sh'"
