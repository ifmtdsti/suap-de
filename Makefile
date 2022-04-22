
ifeq ($(OS), Windows_NT)
    SSH=ssh -p 8022 suap@localhost
else
    SSH=sshpass -psuap ssh -p 8022 suap@localhost
endif

all:

init: init-1 init-2 init-3 init-4 init-5 init-6

start: clear-knownhost start-compose

stop: stop-compose

restart: stop start

shell:

	@-${SSH}

init-1:

	@-if [ ! -d "../suap" ] ; then git clone git@gitlab.ifmt.edu.br:csn/suap.git ../suap; fi
	@-if [ ! -d "../cron" ] ; then git clone git@gitlab.ifmt.edu.br:csn/suap-pc-cron.git ../cron; fi
	@-if [ ! -d "../safe" ] ; then git clone git@gitlab.ifmt.edu.br:csn/suap-pc-safe.git ../safe; fi

init-2:

	@-mkdir -p env/
	@-mkdir -p lib/
	@-mkdir -p lib/env/
	@-mkdir -p lib/git/
	@-mkdir -p lib/ssh/
	@-mkdir -p vol/col/
	@-mkdir -p vol/loc/

init-3:

	@-if [ ! -f .env ] ; then echo "BASE=${HOME}/.opt/suap" > .env; fi

init-4:

	@-if [ ! -f ".env-dba" ] ; then cp lib/env/dba.txt .env-dba; fi
	@-if [ ! -f ".env-git" ] ; then cp lib/env/git.txt .env-git; fi
	@-if [ ! -f ".env-red" ] ; then cp lib/env/red.txt .env-red; fi
	@-if [ ! -f ".env-sql" ] ; then cp lib/env/sql.txt .env-sql; fi

init-5:

	@-cp ${HOME}/.ssh/id_rsa     lib/ssh/id_rsa
	@-cp ${HOME}/.ssh/id_rsa.pub lib/ssh/id_rsa.pub
	@-cp ${HOME}/.ssh/id_rsa.pub lib/ssh/authorized_keys

init-6:

	@-install -D lib/start-gunicorn.sh ../suap/.local/bin/start-gunicorn.sh
	@-install -D lib/stop-gunicorn.sh  ../suap/.local/bin/stop-gunicorn.sh

clear-knownhost:

	@-ssh-keygen -f "${HOME}/.ssh/known_hosts" -R "[localhost]:8022" >/dev/null 2>&1

start-compose: pull-docker

	@docker-compose up --remove-orphans --build --detach

stop-compose:

	@docker-compose down --remove-orphans --volumes

pull-docker:

	@docker pull ifmt/suap-os:latest

start-docker:

	@sudo service docker start

stop-docker:

	@sudo service docker stop

install-pip: install-pip-1 install-pip-2 install-pip-3

	@-${SSH} "bash -l -c 'python -m pip install -r requirements/custom.txt'"

install-pip-1:

	@-${SSH} "bash -l -c 'cd /opt/suap/app && python -m venv .env'"

install-pip-2:

	@-${SSH} "bash -l -c 'python -m pip install --upgrade pip'"

install-pip-3:

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
