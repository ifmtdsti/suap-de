USER := suap

ifeq ($(OS), Windows_NT)

    SSH=ssh -p 8001 ${USER}@localhost

else

    SSH=sshpass -p${USER} ssh -p 8001 ${USER}@localhost

endif

all:

init: init0 init1 init2 init3 init4 init5

start: composeUP

stop: composeDW

build:

	@docker build . --tag ifmt/suap-app --force-rm --no-cache

clear-images: stop

	@docker rmi ifmt/suap-app ifmt/suap-ssh

restart: stop start

shell:

	@-${SSH}

gunicorn:

	@-${SSH} "bash -l -c 'gunicorn --bind 0.0.0.0:8000 --pid ../app.pid --daemon suap.wsgi:application'"

clear-sessions:

	@-${SSH} "bash -l -c 'rm -fr deploy/sessions/session*'"

manage-sync:

	@-${SSH} "bash -l -c 'python manage.py sync'"

manage-password-123:

	@-${SSH} "bash -l -c 'python manage.py set_passwords_to_123'"

init0:

	@-if [ ! -d "../suap" ] ; then git clone git@gitlab.ifmt.edu.br:csn/suap.git ../suap; fi

init1:

	@mkdir -p env/
	@mkdir -p lib/

init2:

	@cp env/env-dba.txt .env-dba
	@cp env/env-red.txt .env-red
	@cp env/env-sql.txt .env-sql

init3:

	@cp ~/.gitconfig lib/gitconfig.txt

init4:

	@mkdir -p lib/ssh/

	@cp ~/.ssh/id_rsa     lib/ssh/id_rsa
	@cp ~/.ssh/id_rsa.pub lib/ssh/id_rsa.pub

init5:

	@mkdir -p lib/pip/

	@cp ../suap/requirements/*.txt lib/pip/

linux1:

	@cp compose.ssh.1.linux.yml compose.ssh.o.yml

linux2:

	@cp compose.ssh.2.linux.yml compose.ssh.o.yml

windows:

	@cp compose.ssh.0.windows.yml compose.ssh.o.yml

composeUP: compose.ssh.m.yml compose.ssh.o.yml

	@docker-compose --file compose.ssh.m.yml --file compose.ssh.o.yml up --remove-orphans --build --detach

composeDW: compose.ssh.m.yml compose.ssh.o.yml

	@docker-compose --file compose.ssh.m.yml --file compose.ssh.o.yml down --remove-orphans --volumes

clearKH:

	@ssh-keygen -f "${HOME}/.ssh/known_hosts" -R "[localhost]:8001" >/dev/null
