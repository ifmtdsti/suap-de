USER := suap

ifeq ($(OS), Windows_NT)

    SSH=ssh -p 8022 ${USER}@localhost

else

    SSH=sshpass -p${USER} ssh -p 8022 ${USER}@localhost

endif

all:

init: init-a init-b init-c init-d init-e

start: clear-known-hosts start-compose

stop: stop-compose

restart: stop start

shell:

	@-${SSH}

init-a:

	@-if [ ! -d "../suap" ] ; then git clone git@gitlab.ifmt.edu.br:csn/suap.git         ../suap; fi
	@-if [ ! -d "../cron" ] ; then git clone git@gitlab.ifmt.edu.br:csn/suap-pc-cron.git ../cron; fi
	@-if [ ! -d "../safe" ] ; then git clone git@gitlab.ifmt.edu.br:csn/suap-pc-safe.git ../safe; fi

init-b:

	@-mkdir -p env/
	@-mkdir -p lib/
	@-mkdir -p lib/env/
	@-mkdir -p lib/git/
	@-mkdir -p lib/ssh/
	@-mkdir -p vcs/

init-c:

	@-if [ ! -f ".env-dba" ] ; then cp lib/env/dba.txt .env-dba; fi
	@-if [ ! -f ".env-git" ] ; then cp lib/env/git.txt .env-git; fi
	@-if [ ! -f ".env-red" ] ; then cp lib/env/red.txt .env-red; fi
	@-if [ ! -f ".env-sql" ] ; then cp lib/env/sql.txt .env-sql; fi

init-d:

	@-cp ${HOME}/.ssh/id_rsa     lib/ssh/id_rsa
	@-cp ${HOME}/.ssh/id_rsa.pub lib/ssh/id_rsa.pub
	@-cp ${HOME}/.ssh/id_rsa.pub lib/ssh/authorized_keys

init-e:

	@-install -D lib/start-gunicorn.sh ../suap/.local/bin/start-gunicorn.sh
	@-install -D lib/stop-gunicorn.sh  ../suap/.local/bin/stop-gunicorn.sh

clear-known-hosts:

	@-ssh-keygen -f "${HOME}/.ssh/known_hosts" -R "[localhost]:8022" >/dev/null 2>&1

start-compose: pull-docker

	@docker-compose --file compose.m.yml --file compose.o.yml up --remove-orphans --build --detach

stop-compose:

	@docker-compose --file compose.m.yml --file compose.o.yml down --remove-orphans --volumes

pull-docker:

	@docker pull ifmt/suap-os:latest

set-linux1:

	@cp compose.1.linux.yml compose.o.yml

set-linux2:

	@cp compose.2.linux.yml compose.o.yml

set-linux: set-linux-1

set-windows:

	@cp compose.0.windows.yml compose.o.yml

start-docker:

	@sudo service docker start

stop-docker:

	@sudo service docker stop

install-pip: install-pip-a install-pip-b install-pip-c

	@-${SSH} "bash -l -c 'python -m pip install -r requirements/custom.txt'"

install-pip-a:

	@-${SSH} "bash -l -c 'cd /opt/suap/app && python -m venv .env'"

install-pip-b:

	@-${SSH} "bash -l -c 'python -m pip install --upgrade pip'"

install-pip-c:

	@-${SSH} "bash -l -c 'python -m pip install wheel'"

uninstall-pip:

	@-${SSH} "bash -l -c 'cd /opt/suap/app && deactivate && rm -fr .env/*'"

manage-sync:

	@-${SSH} "bash -l -c 'python manage.py sync'"

manage-password:

	@-${SSH} "bash -l -c 'python manage.py set_passwords_to 123147'"

start-gunicorn:

	@-${SSH} "bash -l -c '.local/bin/start-gunicorn.sh'"

stop-gunicorn:

	@-${SSH} "bash -l -c '.local/bin/stop-gunicorn.sh'"
