USER := suap

all:

init1:

	@git clone git@gitlab.ifmt.edu.br:csn/suap.git ../suap

init2:

	@mkdir -p opt/.ssh

	@cp ~/.ssh/id_rsa     opt/.ssh/id_rsa
	@cp ~/.ssh/id_rsa.pub opt/.ssh/id_rsa.pub

init3:

	@cp ../suap/requirements/base.txt requirements.txt

init4:

	@cp ./lib/bashrc  opt/.bashrc
	@cp ./lib/profile opt/.profile

init: init1 init2 init3 init4

build:

	@docker build . --tag suap_app --force-rm --no-cache

linux1:

	@cp compose.1.linux.yml compose.ssh.o.yml

linux2:

	@cp compose.2.linux.yml compose.ssh.o.yml

windows:

	@cp compose.0.windows.yml compose.ssh.o.yml

sshUP:

	@docker-compose --file compose.ssh.m.yml --file compose.ssh.o.yml up --remove-orphans --build --detach

sshDW:

	@docker-compose --file compose.ssh.m.yml --file compose.ssh.o.yml down --remove-orphans --volumes

start: sshUP

stop: sshDW

restart: stop start

ssh:

	@sshpass -p${USER} ssh -p 8022 ${USER}@localhost

run:

	@sshpass -p${USER} ssh -p 8022 ${USER}@localhost "bash -l -c './manage.py runserver 0.0.0.0:8000 >/dev/null &'"

sshx:

	@sshpass -p${USER} ssh -p 8022 ${USER}@localhost

runx:

	@sshpass -p${USER} ssh -p 8022 ${USER}@localhost "bash -l -c './manage.py runserver 0.0.0.0:8000 >/dev/null &'"
