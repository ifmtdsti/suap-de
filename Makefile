PROJECT := suap

all:

init1:

	@git clone git@gitlab.ifmt.edu.br:csn/suap.git ../suap

init2:

	@cp ~/.ssh/id_rsa.ifmt     opt/.ssh/id_rsa
	@cp ~/.ssh/id_rsa.ifmt.pub opt/.ssh/id_rsa.pub

init3:

	@cp ./lib/bashrc    opt/.bashrc
	@cp ./lib/profile   opt/.profile
	@cp ./lib/runserver opt/runserver.sh

	@chmod +x opt/runserver.sh

init: init1 init2 init3

set1:

	@cp docker-compose.1.yml docker-compose.override.yml

set2:

	@cp docker-compose.2.yml docker-compose.override.yml

dcUP:

	@docker-compose -p $(PROJECT) up -d --build --remove-orphans

dcDW:

	@docker-compose -p $(PROJECT) down --remove-orphans

dcCL:

	@docker volume rm $(PROJECT)_dba
	@docker volume rm $(PROJECT)_lda
	@docker volume rm $(PROJECT)_red
	@docker volume rm $(PROJECT)_sql
	@docker volume rm $(PROJECT)_app
	@docker volume rm $(PROJECT)_opt

start: dcUP

stop: dcDW dcCL

restart: stop start

ssh:

	@sshpass -psuap ssh -p 8022 suap@localhost

run:

	sshpass -psuap ssh -p 8022 -o ServerAliveInterval=60 suap@localhost "bash -l -c './manage.py runserver 0.0.0.0:8000 >/dev/null &'"
