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

init: init-01 init-02 init-03 init-04 init-05 init-06 init-07 init-08 init-09 init-10

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

	@-${SSH} "bash -l -c 'gunicorn suap.wsgi:application --bind=0.0.0.0:8000 --pid=../app.pid --workers=4 --daemon'"

manage-sync:

	@-${SSH} "bash -l -c 'python manage.py sync'"

manage-password-123:

	@-${SSH} "bash -l -c 'python manage.py set_passwords_to_123'"

init-01:

	@-if [ ! -d "../suap" ] ; then git clone git@gitlab.ifmt.edu.br:csn/suap.git ../suap; fi

init-02:

	@-if [ ! -d "../cron" ] ; then git clone git@gitlab.ifmt.edu.br:carlosrabelo/update-suap-pc.git ../cron; fi

init-03:

	@mkdir -p env/

init-04:

	@mkdir -p lib/env
	@mkdir -p lib/git
	@mkdir -p lib/pip
	@mkdir -p lib/ssh

init-05:

	@cp lib/env/dba.txt .env-dba
	@cp lib/env/red.txt .env-red
	@cp lib/env/sql.txt .env-sql

init-06:

	@cp ${HOME}/.gitconfig lib/git/gitconfig.txt

init-07:

	@mkdir -p lib/ssh/

init-08:

	@cp ${HOME}/.ssh/id_rsa     lib/ssh/id_rsa
	@cp ${HOME}/.ssh/id_rsa.pub lib/ssh/id_rsa.pub
	@cp ${HOME}/.ssh/id_rsa.pub lib/ssh/authorized_keys

init-09:

	@mkdir -p lib/pip/

init-10:

	@cp ../suap/requirements/*.txt lib/pip/

compose-up:

	@docker-compose --file compose.ssh.m.yml --file compose.ssh.o.yml up --remove-orphans --build --detach

compose-dw:

	@docker-compose --file compose.ssh.m.yml --file compose.ssh.o.yml down --remove-orphans --volumes

set-linux1:

	@cp compose.ssh.1.linux.yml compose.ssh.o.yml

set-linux2:

	@cp compose.ssh.2.linux.yml compose.ssh.o.yml

set-windows:

	@cp compose.ssh.0.windows.yml compose.ssh.o.yml
