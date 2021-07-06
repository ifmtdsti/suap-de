PROJECT := ifmt

LASTEST := carlosrabelo/suap-dv:latest
CURRENT := carlosrabelo/suap-dv:18.04

restart: stop start

start:
	@docker-compose -p $(PROJECT) up -d --build

stop:
	@docker-compose -p $(PROJECT) down

ssh:
	@ssh -p 8022 suap@localhost

init:
	@git clone git@gitlab.ifmt.edu.br:csn/suap.git src
	@cp ./lib/bashrc ./src/.bashrc
	@cp ./lib/profile ./src/.profile
