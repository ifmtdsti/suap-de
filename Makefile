USER := suap

ifeq ($(OS), Windows_NT)

    SSH=ssh -p 8022 ${USER}@localhost

else

    SSH=sshpass -p${USER} ssh -p 8022 ${USER}@localhost

endif

all:

init1:

	@git clone git@gitlab.ifmt.edu.br:csn/suap.git ../suap

init2:

	@mkdir -p lib

	echo ${EXECUTABLE}

init3:

	@cp ~/.ssh/id_rsa     lib/id_rsa
	@cp ~/.ssh/id_rsa.pub lib/id_rsa.pub

init4:

	@cp ./env/env-dba.txt .env-dba
	@cp ./env/env-red.txt .env-red
	@cp ./env/env-sql.txt .env-sql

init5:

	@cp ../suap/requirements/base.txt lib/requirements.txt

init: init1 init2 init3 init4 init5

build:

	@docker build . --tag ifmt/suap-app --force-rm --no-cache

linux1:

	@cp compose.ssh.1.linux.yml compose.ssh.o.yml
	@cp compose.ssh.1.linux.yml docker-compose.override.yml

linux2:

	@cp compose.ssh.2.linux.yml compose.ssh.o.yml
	@cp compose.ssh.2.linux.yml docker-compose.override.yml

windows:

	@cp compose.ssh.0.windows.yml compose.ssh.o.yml
	@cp compose.ssh.0.windows.yml docker-compose.override.yml

startUP: compose.ssh.o.yml

	@docker-compose --file compose.ssh.m.yml --file compose.ssh.o.yml up --remove-orphans --build --detach

startDW: compose.ssh.o.yml

	@docker-compose --file compose.ssh.m.yml --file compose.ssh.o.yml down --remove-orphans --volumes

start: startUP

stop: startDW

restart: stop start

clearKH:

	@ssh-keygen -f "${HOME}/.ssh/known_hosts" -R "[localhost]:8022" >/dev/null

ssh:

	@${SSH}

gunicorn:

	@${SSH} "bash -l -c 'gunicorn --bind=0.0.0.0:8000 --config=bin/gunicorn_docker.conf --daemon  suap.wsgi:application'"

manage-sync:

	@${SSH} "bash -l -c 'python manage.py sync'"

manage-password-123:

	@${SSH} "bash -l -c 'python manage.py set_passwords_to_123'"
