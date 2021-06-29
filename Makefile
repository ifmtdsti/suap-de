PROJECT := suap

LASTEST := carlosrabelo/suap-dv:latest
CURRENT := carlosrabelo/suap-dv:18.04

restart: stop start

start:
	@docker-compose -p $(PROJECT) up -d --build

stop:
	@docker-compose -p $(PROJECT) down

shell:
	@ssh -p 8022 suap@localhost
