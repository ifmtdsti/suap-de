PROJECT := ifmt

LASTEST := carlosrabelo/suap-dv:latest
CURRENT := carlosrabelo/suap-dv:18.04

clean:
	@docker network rm $(PROJECT)_suap-network
	@docker volume rm $(PROJECT)_app
	@docker volume rm $(PROJECT)_dba
	@docker volume rm $(PROJECT)_lda
	@docker volume rm $(PROJECT)_sql

start:
	@docker-compose -p $(PROJECT) up -d --build

stop:
	@docker-compose -p $(PROJECT) down

restart: stop start

ssh:
	@ssh -p 8022 suap@localhost

init:
	@git clone git@gitlab.ifmt.edu.br:csn/suap.git src
	@cp ./lib/bashrc ./src/.bashrc
	@cp ./lib/profile ./src/.profile
