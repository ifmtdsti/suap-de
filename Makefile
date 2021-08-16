PROJECT := suap

all:

init1:

	@git clone git@gitlab.ifmt.edu.br:csn/suap.git ../suap

init2:

	@cp ./lib/bashrc ../suap/.bashrc
	@cp ./lib/profile ../suap/.profile

init: init1 init2

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

start: dcUP

stop: dcDW dcCL

restart: stop start

ssh:

	@sshpass -pdsti ssh -p 8022 dsti@localhost

run:

	sshpass -pdsti ssh -p 8022 -o ServerAliveInterval=60  dsti@localhost "/app/bin/runserver.sh >&/dev/null &"
