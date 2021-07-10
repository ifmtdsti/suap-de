PROJECT := suap

all:

step1:

	@git clone git@gitlab.ifmt.edu.br:csn/suap.git ../suap

step2:

	@cp ./lib/bashrc ../suap/.bashrc
	@cp ./lib/profile ../suap/.profile

init: step1 step2

clean1:

	@docker network rm $(PROJECT)_app

clean2:

	@docker volume rm $(PROJECT)_dba
	@docker volume rm $(PROJECT)_lda
	@docker volume rm $(PROJECT)_red
	@docker volume rm $(PROJECT)_sql
	@docker volume rm $(PROJECT)_app

clean: clean2

start:

	@docker-compose -p $(PROJECT) up -d --build --remove-orphans

stop:

	@docker-compose -p $(PROJECT) down --remove-orphans

restart: stop start

ssh:

	@ssh -p 8022 ifmt@localhost
