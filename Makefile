APP=suap

ifeq ($(OS), Windows_NT)
    SSH=ssh -p 8022 ${APP}@localhost
else
    SSH=sshpass -p${APP} ssh -p 8022 ${APP}@localhost
endif

all:

start: init start-compose

stop: stop-compose

restart: stop start

init:

	@-bash bin/init.sh

shell:

	@-${SSH}

start-compose: pull-docker

	@docker-compose up --build --detach --force-recreate --remove-orphans

stop-compose:

	@docker-compose down --remove-orphans --volumes

pull-docker:

	@docker pull ifmt/suap-os:latest

start-docker:

	@sudo service docker start

stop-docker:

	@sudo service docker stop

install-pip:

	@-${SSH} "bash -l -c '.local/bin/install-pip.sh'"

uninstall-pip:

	@-${SSH} "bash -l -c '.local/bin/uninstall-pip.sh'"

refresh-app:

	@-${SSH} "bash -l -c '.local/bin/refresh-app.sh'"

start-gunicorn:

	@-${SSH} "bash -l -c '.local/bin/start-gunicorn.sh'"

stop-gunicorn:

	@-${SSH} "bash -l -c '.local/bin/stop-gunicorn.sh'"

restart-gunicorn: stop-gunicorn start-gunicorn
