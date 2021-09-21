USER := suap

ifeq ($(OS), Windows_NT)

    SSH=ssh -p 8022 ${USER}@localhost

else

    SSH=sshpass -p${USER} ssh -p 8022 ${USER}@localhost

endif

all:

init: init1 init2 init3 init4 init5

build:

	@docker build --file compose.app.m.yml --file compose.app.o.yml --tag ifmt/suap-app --force-rm --no-cache

start: startUP

stop: startDW

restart: stop start

shell:

	@${SSH}

gunicorn:

	@${SSH} "bash -l -c 'gunicorn --bind 0.0.0.0:8000 --config bin/gunicorn_docker.conf --pid ../app.pid --daemon suap.wsgi:application'"

manage-sync:

	@${SSH} "bash -l -c 'python manage.py sync'"

manage-password-123:

	@${SSH} "bash -l -c 'python manage.py set_passwords_to_123'"

init1:

	@git clone git@gitlab.ifmt.edu.br:csn/suap.git ../suap

init2:

	@mkdir -p lib

init3:

	@cp ~/.ssh/id_rsa     lib/id_rsa
	@cp ~/.ssh/id_rsa.pub lib/id_rsa.pub

init4:

	@cp ./env/env-dba.txt .env-dba
	@cp ./env/env-red.txt .env-red
	@cp ./env/env-sql.txt .env-sql

init5:

	@cp ../suap/requirements/*.txt lib/

linux1:

	@cp compose.ssh.1.linux.yml compose.ssh.o.yml

linux2:

	@cp compose.ssh.2.linux.yml compose.ssh.o.yml

windows:

	@cp compose.ssh.0.windows.yml compose.ssh.o.yml

startUP: compose.ssh.m.yml compose.ssh.o.yml

	@docker-compose --file compose.ssh.m.yml --file compose.ssh.o.yml up --remove-orphans --build --detach

startDW: compose.ssh.m.yml compose.ssh.o.yml

	@docker-compose --file compose.ssh.m.yml --file compose.ssh.o.yml down --remove-orphans --volumes

clearKH:

	@ssh-keygen -f "${HOME}/.ssh/known_hosts" -R "[localhost]:8022" >/dev/null
