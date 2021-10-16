USER := suap

ifeq ($(OS), Windows_NT)

    SSH=ssh -p 8022 ${USER}@localhost

else

    SSH=sshpass -p${USER} ssh -p 8022 ${USER}@localhost

endif

all:

start-docker:

	@sudo service docker start

stop-docker:

	@sudo service docker stop

start: compose-up clearKH

stop: compose-dw

restart: stop start

init: init1 init2 init3 init4 init5 init6 init7

clearKH:

	@-ssh-keygen -f "${HOME}/.ssh/known_hosts" -R "[localhost]:8022" >/dev/null 2>&1

build:

	@docker build . --tag ifmt/suap-app --force-rm --no-cache

clear-images: stop

	@docker rmi ifmt/suap-app ifmt/suap-ssh

shell:

	@-${SSH}

virtual-env:

	@-${SSH} "bash -l -c 'virtualenv -p python3 env'"

pip-install:

	@-${SSH} "bash -l -c 'pip install -r requirements/development.txt'"

pip-uninstall:

	@-${SSH} "bash -l -c 'deactivate && rm -fr ../env/*'"

gunicorn:

	@-${SSH} "bash -l -c 'gunicorn --bind 0.0.0.0:8000 --pid ../app.pid --daemon suap.wsgi:application'"

manage-sync:

	@-${SSH} "bash -l -c 'python manage.py sync'"

manage-password-123:

	@-${SSH} "bash -l -c 'python manage.py set_passwords_to_123'"

init1:

	@-if [ ! -d "../suap" ] ; then git clone git@gitlab.ifmt.edu.br:csn/suap.git ../suap; fi

init2:

	@-if [ ! -d "../cron" ] ; then git clone git@gitlab.ifmt.edu.br:carlosrabelo/update-suap-pc.git ../cron; fi

init3:

	@mkdir -p env/
	@mkdir -p lib/env
	@mkdir -p lib/git
	@mkdir -p lib/pip
	@mkdir -p lib/ssh

init4:

	@cp lib/env/dba.txt .env-dba
	@cp lib/env/red.txt .env-red
	@cp lib/env/sql.txt .env-sql

init5:

	@cp ${HOME}/.gitconfig lib/git/gitconfig.txt

init6:

	@mkdir -p lib/ssh/

	@cp ${HOME}/.ssh/id_rsa     lib/ssh/id_rsa
	@cp ${HOME}/.ssh/id_rsa.pub lib/ssh/id_rsa.pub
	@cp ${HOME}/.ssh/id_rsa.pub lib/ssh/authorized_keys

init7:

	@mkdir -p lib/pip/

	@cp ../suap/requirements/*.txt lib/pip/

compose-up: compose.ssh.m.yml compose.ssh.o.yml

	@docker-compose --file compose.ssh.m.yml --file compose.ssh.o.yml up --remove-orphans --build --detach

compose-dw: compose.ssh.m.yml compose.ssh.o.yml

	@docker-compose --file compose.ssh.m.yml --file compose.ssh.o.yml down --remove-orphans --volumes

set-linux1:

	@cp compose.ssh.1.linux.yml compose.ssh.o.yml

set-linux2:

	@cp compose.ssh.2.linux.yml compose.ssh.o.yml

set-windows:

	@cp compose.ssh.0.windows.yml compose.ssh.o.yml
