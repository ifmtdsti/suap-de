FROM ifmt/suap-os:latest

ARG CACHE_BUST=1

ENV DEBIAN_FRONTEND=noninteractive

ENV LANG=pt_BR.UTF-8
ENV LANGUAGE=pt_BR:en
ENV LC_ALL=pt_BR.UTF-8

RUN locale-gen pt_BR.UTF-8 && groupadd -g 1000 suap && useradd -rm -d /app -s /bin/bash -g suap -G sudo -u 1000 suap && echo 'suap:suap' | chpasswd

RUN service ssh start

USER suap

WORKDIR /app

ADD --chown=suap:suap lib/bash_aliases.sh     .bash_aliases
ADD --chown=suap:suap lib/bashrc.sh           .bashrc
ADD --chown=suap:suap lib/profile.sh          .profile
ADD --chown=suap:suap lib/ssh/id_rsa          .ssh/id_rsa
ADD --chown=suap:suap lib/ssh/id_rsa.pub      .ssh/id_rsa.pub
ADD --chown=suap:suap lib/ssh/authorized_keys .ssh/authorized_keys

RUN code-server --install-extension ms-python.python
RUN code-server --install-extension ms-toolsai.jupyter

USER root

RUN mkdir -p /var/log/supervisor

COPY lib/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

CMD [ "/usr/bin/supervisord" ]
