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

compose-start:

	@docker-compose --file compose.ssh.m.yml --file compose.ssh.o.yml up --remove-orphans --build --detach

compose-stop:

	@docker-compose --file compose.ssh.m.yml --file compose.ssh.o.yml down --remove-orphans --volumes

start: compose-start clear-known-hosts

stop: compose-stop

restart: stop start

init-01:

	@-if [ ! -d "../suap" ] ; then git clone git@gitlab.ifmt.edu.br:csn/suap.git ../suap; fi

init-02:

	@-if [ ! -d "../cron" ] ; then git clone git@gitlab.ifmt.edu.br:carlosrabelo/update-suap-pc.git ../cron; fi

init-03:

	@cp ${HOME}/.gitconfig ../suap/.gitconfig

init-04:

	@cp lib/bashrc.txt ../suap/.bashrc

init-05:

	@mkdir -p env/

init-06:

	@mkdir -p lib/env/
	@mkdir -p lib/git/
	@mkdir -p lib/pip/
	@mkdir -p lib/ssh/

init-07:

	@cp lib/env/dba.txt .env-dba
	@cp lib/env/red.txt .env-red
	@cp lib/env/sql.txt .env-sql

init-08:

	@cp ${HOME}/.ssh/id_rsa     lib/ssh/id_rsa
	@cp ${HOME}/.ssh/id_rsa.pub lib/ssh/id_rsa.pub
	@cp ${HOME}/.ssh/id_rsa.pub lib/ssh/authorized_keys

init-09:

	@cp ../suap/requirements/*.txt lib/pip/

init: init-01 init-02 init-03 init-04 init-05 init-06 init-07 init-08 init-09

set-linux1:

	@cp compose.ssh.1.linux.yml compose.ssh.o.yml

set-linux2:

	@cp compose.ssh.2.linux.yml compose.ssh.o.yml

set-linux: set-linux-1

set-windows:

	@cp compose.ssh.0.windows.yml compose.ssh.o.yml

shell:

	@-${SSH}

gunicorn:

	@-${SSH} "bash -l -c 'gunicorn suap.wsgi:application --bind=0.0.0.0:8000 --pid=../app.pid --workers=4 --daemon'"

manage-sync:

	@-${SSH} "bash -l -c 'python manage.py sync'"

manage-password:

	@-${SSH} "bash -l -c 'python manage.py set_passwords_to 123147'"

build:

	@docker build . --tag ifmt/suap-app --force-rm --no-cache

clear-known-hosts:

	@-ssh-keygen -f "${HOME}/.ssh/known_hosts" -R "[localhost]:8022" >/dev/null 2>&1

clear-images: stop

	@docker rmi -f ifmt/suap-app ifmt/suap-ssh

pip-install-01:

	@-${SSH} "bash -l -c 'python -m venv env'"

pip-install-02:

	@-${SSH} "bash -l -c 'python -m pip install --upgrade pip'"

pip-install-03:

	@-${SSH} "bash -l -c 'python -m pip install wheel'"

pip-install: pip-install-01 pip-install-02 pip-install-03

	@-${SSH} "bash -l -c 'python -m pip install -r requirements/production.txt -r requirements/development.txt'"

pip-uninstall:

	@-${SSH} "bash -l -c 'deactivate && rm -fr /opt/suap/env/*'"
