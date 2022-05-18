FROM ifmt/suap-vc:latest

ENV DEBIAN_FRONTEND=noninteractive

ENV LANG=pt_BR.UTF-8
ENV LANGUAGE=pt_BR:en
ENV LC_ALL=pt_BR.UTF-8

RUN locale-gen pt_BR.UTF-8 && groupadd -g 1000 suap && useradd -rm -d /app -s /bin/bash -g suap -G sudo -u 1000 suap && echo 'suap:suap' | chpasswd

USER suap

WORKDIR /app

ADD --chown=suap:suap lib/bin/bash_aliases.sh .bash_aliases
ADD --chown=suap:suap lib/bin/bashrc.sh       .bashrc
ADD --chown=suap:suap lib/bin/profile.sh      .profile

RUN code-server --install-extension ms-python.python
RUN code-server --install-extension ms-toolsai.jupyter

USER root

RUN service ssh start

RUN mkdir -p /var/log/supervisor

COPY lib/etc/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

CMD [ "/usr/bin/supervisord" ]
