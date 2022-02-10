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

known-hosts-clear:

	@-ssh-keygen -f "${HOME}/.ssh/known_hosts" -R "[localhost]:8022" >/dev/null 2>&1

start: compose-start known-hosts-clear

stop: compose-stop

restart: stop start

init-a:

	@-if [ ! -d "../suap" ] ; then git clone git@gitlab.ifmt.edu.br:csn/suap.git         ../suap; fi
	@-if [ ! -d "../cron" ] ; then git clone git@gitlab.ifmt.edu.br:csn/suap-pc-cron.git ../cron; fi
	@-if [ ! -d "../safe" ] ; then git clone git@gitlab.ifmt.edu.br:csn/suap-pc-safe.git ../safe; fi

init-b:

	@-mkdir -p env/

init-c:

	@-mkdir -p lib/env/
	@-mkdir -p lib/git/
	@-mkdir -p lib/pip/
	@-mkdir -p lib/ssh/

init-d:

	@cp lib/bashrc.txt ../suap/.bashrc

init-e:

	@cp lib/git/gitconfig.txt ../suap/.gitconfig

init-f:

	@cp lib/env/dba.txt .env-dba
	@cp lib/env/red.txt .env-red
	@cp lib/env/sql.txt .env-sql

init-g:

	@cp ${HOME}/.ssh/id_rsa     lib/ssh/id_rsa
	@cp ${HOME}/.ssh/id_rsa.pub lib/ssh/id_rsa.pub
	@cp ${HOME}/.ssh/id_rsa.pub lib/ssh/authorized_keys

init-h:

	@cp ../suap/requirements/*.txt lib/pip/

init: init-a init-b init-c init-d init-e init-f init-g init-h

set-linux1:

	@cp compose.ssh.1.linux.yml compose.ssh.o.yml

set-linux2:

	@cp compose.ssh.2.linux.yml compose.ssh.o.yml

set-linux: set-linux-1

set-windows:

	@cp compose.ssh.0.windows.yml compose.ssh.o.yml

shell:

	@-${SSH}

pip-install-a:

	@-${SSH} "bash -l -c 'cd /opt/suap && python -m venv env'"

pip-install-b:

	@-${SSH} "bash -l -c 'python -m pip install --upgrade pip'"

pip-install-c:

	@-${SSH} "bash -l -c 'python -m pip install wheel'"

pip-install: pip-install-a pip-install-b pip-install-c

	@-${SSH} "bash -l -c 'python -m pip install -r requirements/custom.txt'"

pip-uninstall:

	@-${SSH} "bash -l -c 'deactivate && rm -fr /opt/suap/env/*'"

manage-sync:

	@-${SSH} "bash -l -c 'python manage.py sync'"

manage-password:

	@-${SSH} "bash -l -c 'python manage.py set_passwords_to 123147'"

gunicorn:

	@-${SSH} "bash -l -c 'gunicorn suap.wsgi:application --pid=../app.pid --bind=0.0.0.0:8000 --workers=`nproc` --timeout=1800 --log-file=gunicorn1.log --daemon >> gunicorn2.log'"

build:

	@docker build . --tag ifmt/suap-app --force-rm --no-cache

images-clear: stop

	@docker rmi -f ifmt/suap-app ifmt/suap-ssh
