
ifeq ($(OS), Windows_NT)
    SSH=ssh -p 8022 suap@localhost
else
    SSH=sshpass -psuap ssh -p 8022 suap@localhost
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

install-pip: install-pip-1 install-pip-2 install-pip-3

	@-${SSH} "bash -l -c 'python -m pip install -r requirements/custom.txt'"

install-pip-1:

	@-${SSH} "bash -l -c 'cd /app/suap && python3 -m venv .env'"

install-pip-2:

	@-${SSH} "bash -l -c 'python -m pip install --upgrade pip'"

install-pip-3:

	@-${SSH} "bash -l -c 'python -m pip install wheel'"

uninstall-pip:

	@-${SSH} "bash -l -c 'cd /app/suap && deactivate && rm -fr .env/*'"

manage-migrate:

	@-${SSH} "bash -l -c 'python manage.py migrate'"

manage-sync:

	@-${SSH} "bash -l -c 'python manage.py sync'"

manage-password:

	@-${SSH} "bash -l -c 'python manage.py set_passwords_to 123147'"

restart-gunicorn: stop-gunicorn start-gunicorn

start-gunicorn:

	@-${SSH} "bash -l -c '.local/bin/start-gunicorn.sh'"

stop-gunicorn:

	@-${SSH} "bash -l -c '.local/bin/stop-gunicorn.sh'"
