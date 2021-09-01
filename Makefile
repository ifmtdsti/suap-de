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

linux1:

	@cp docker-compose.linux.1.yml docker-compose.override.yml

linux2:

	@cp docker-compose.linux.2.yml docker-compose.override.yml

windows:

	@cp docker-compose.windows.yml docker-compose.override.yml

build-suap-app:
	@docker build . --tag suap_app --force-rm --no-cache

composeUP:

	@docker-compose up --detach --build --remove-orphans

composeDW:

	@docker-compose down --remove-orphans

composeCL:

	@docker volume rm suap_ssh
	@docker volume rm suap_opt
	@docker volume rm suap_dba
	@docker volume rm suap_red
	@docker volume rm suap_sql

start: composeUP

stop: composeDW composeCL

restart: stop start

ssh:

	@sshpass -p${USER} ssh -p 8022 ${USER}@localhost

run:

	@sshpass -p${USER} ssh -p 8022 ${USER}@localhost "bash -l -c './manage.py runserver 0.0.0.0:8000 >/dev/null &'"
