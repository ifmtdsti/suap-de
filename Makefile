USER := suap

all:

init1:

	@git clone git@gitlab.ifmt.edu.br:csn/suap.git ../suap

init2:

	@mkdir -p opt/.ssh

init3:

	@cp ~/.ssh/id_rsa     opt/.ssh/id_rsa
	@cp ~/.ssh/id_rsa.pub opt/.ssh/id_rsa.pub

init4:

	@cp ./lib/bashrc.txt  opt/.bashrc
	@cp ./lib/profile.txt opt/.profile

init5:

	@cp ./lib/env-dba.txt .env-dba
	@cp ./lib/env-red.txt .env-red
	@cp ./lib/env-sql.txt .env-sql

init6:

	@cp ../suap/requirements/base.txt requirements.txt

init: init1 init2 init3 init4 init5 initi6

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

sshUP:

	@docker-compose --file compose.ssh.m.yml --file compose.ssh.o.yml up --remove-orphans --build --detach

sshDW:

	@docker-compose --file compose.ssh.m.yml --file compose.ssh.o.yml down --remove-orphans --volumes

start: sshUP

stop: sshDW

restart: stop start

ssh:

	@ssh -p 8022 ${USER}@localhost

run:

	@ssh -p 8022 ${USER}@localhost "bash -l -c './manage.py runserver 0.0.0.0:8000 >/dev/null &'"

clearKH:

	@ssh-keygen -f "${HOME}/.ssh/known_hosts" -R "[localhost]:8022" >/dev/null

xssh: clearKH

	@sshpass -p${USER} ssh -p 8022 ${USER}@localhost

xrun: clearKH

	@sshpass -p${USER} ssh -p 8022 ${USER}@localhost "bash -l -c './manage.py runserver 0.0.0.0:8000 >/dev/null &'"
