FROM ifmt/suap-os:latest

ENV DEBIAN_FRONTEND=noninteractive

ENV LANG=pt_BR.UTF-8
ENV LANGUAGE=pt_BR:en
ENV LC_ALL=pt_BR.UTF-8

RUN locale-gen pt_BR.UTF-8 && groupadd -g 1000 suap && useradd -rm -d /opt/suap -s /bin/bash -g suap -G sudo -u 1000 suap && echo 'suap:suap' | chpasswd

RUN service ssh start

RUN mkdir -p /var/log/supervisor

USER suap

WORKDIR /opt/suap

ADD --chown=suap:suap lib/bashrc.txt          .bashrc
ADD --chown=suap:suap lib/profile.txt         .profile
ADD --chown=suap:suap lib/ssh/id_rsa          .ssh/id_rsa
ADD --chown=suap:suap lib/ssh/id_rsa.pub      .ssh/id_rsa.pub
ADD --chown=suap:suap lib/ssh/authorized_keys .ssh/authorized_keys
ADD --chown=suap:suap lib/git/gitconfig.txt   app/.gitconfig

RUN code-server --install-extension ms-python.python

USER root

COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

CMD [ "/usr/bin/supervisord" ]
