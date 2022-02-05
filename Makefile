USER := suap

ifeq ($(OS), Windows_NT)

    SSH=ssh -p 8022 ${USER}@localhost

else

    SSH=sshpass -p${USER} ssh -p 8022 ${USER}@localhost

endif

all:

start-docker:

	@sudo service docker start

stop-docker:

	@sudo service docker stop

compose-start:

	@docker-compose --file compose.ssh.m.yml --file compose.ssh.o.yml up --remove-orphans --build --detach

compose-stop:

	@docker-compose --file compose.ssh.m.yml --file compose.ssh.o.yml down --remove-orphans --volumes

start: compose-start clear-known-hosts

stop: compose-stop

restart: stop start

init-a:

	@-if [ ! -d "../suap" ] ; then git clone git@gitlab.ifmt.edu.br:csn/suap.git ../suap; fi

init-b:

	@-if [ ! -d "../cron" ] ; then git clone git@gitlab.ifmt.edu.br:csn/suap-pc-cron.git ../cron; fi

init-c:

	@-if [ ! -d "../safe" ] ; then git clone git@gitlab.ifmt.edu.br:csn/suap-pc-safe.git ../safe; fi

init-d:

	@-mkdir -p env/

init-e:

	@-mkdir -p lib/env/
	@-mkdir -p lib/git/
	@-mkdir -p lib/pip/
	@-mkdir -p lib/ssh/

init-f:

	@cp lib/bashrc.txt ../suap/.bashrc

init-g:

	@cp lib/git/gitconfig.txt ../suap/.gitconfig

init-h:

	@cp lib/env/dba.txt .env-dba
	@cp lib/env/red.txt .env-red
	@cp lib/env/sql.txt .env-sql

init-i:

	@cp ${HOME}/.ssh/id_rsa     lib/ssh/id_rsa
	@cp ${HOME}/.ssh/id_rsa.pub lib/ssh/id_rsa.pub
	@cp ${HOME}/.ssh/id_rsa.pub lib/ssh/authorized_keys

init-j:

	@cp ../suap/requirements/*.txt lib/pip/

init: init-a init-b init-c init-d init-e init-f init-g init-h init-i init-j

set-linux1:

	@cp compose.ssh.1.linux.yml compose.ssh.o.yml

set-linux2:

	@cp compose.ssh.2.linux.yml compose.ssh.o.yml

set-linux: set-linux-1

set-windows:

	@cp compose.ssh.0.windows.yml compose.ssh.o.yml

shell:

	@-${SSH}

gunicorn:
	@-${SSH} "bash -l -c 'gunicorn suap.wsgi:application --pid=../app.pid --bind=0.0.0.0:8000 --workers=`nproc` --timeout=1800 --log-file=deploy/logs/gunicorn/gunicorn1.log --daemon >>deploy/logs/gunicorn/gunicorn2.log'"

manage-sync:

	@-${SSH} "bash -l -c 'python manage.py sync'"

manage-password:

	@-${SSH} "bash -l -c 'python manage.py set_passwords_to 123147'"

build:

	@docker build . --tag ifmt/suap-app --force-rm --no-cache

clear-known-hosts:

	@-ssh-keygen -f "${HOME}/.ssh/known_hosts" -R "[localhost]:8022" >/dev/null 2>&1

clear-images: stop

	@docker rmi -f ifmt/suap-app ifmt/suap-ssh

pip-install-01:

	@-${SSH} "bash -l -c 'cd /opt/suap && python -m venv env'"

pip-install-02:

	@-${SSH} "bash -l -c 'python -m pip install --upgrade pip'"

pip-install-03:

	@-${SSH} "bash -l -c 'python -m pip install wheel'"

pip-install: pip-install-01 pip-install-02 pip-install-03

	@-${SSH} "bash -l -c 'python -m pip install -r requirements/custom.txt'"

pip-uninstall:

	@-${SSH} "bash -l -c 'deactivate && rm -fr /opt/suap/env/*'"
