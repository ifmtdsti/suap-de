FROM ifmt/suap-vc:latest

ENV DEBIAN_FRONTEND=noninteractive

ENV LANG=pt_BR.UTF-8
ENV LANGUAGE=pt_BR:en
ENV LC_ALL=pt_BR.UTF-8

RUN locale-gen pt_BR.UTF-8 && \
    groupadd -g 1000 suap && \
    useradd -rm -d /app -s /bin/bash -g suap -G sudo -u 1000 suap && \
    echo 'suap:suap' | chpasswd

RUN service ssh start

RUN mkdir -p /var/log/supervisor

COPY lib/etc/supervisor.txt /etc/supervisor/conf.d/suap.conf
COPY lib/etc/tasks.txt      /etc/cron.d/tasks

USER suap

WORKDIR /app

ADD --chown=suap:suap lib/bin/bash_aliases.sh .bash_aliases
ADD --chown=suap:suap lib/bin/bashrc.sh       .bashrc
ADD --chown=suap:suap lib/bin/profile.sh      .profile

RUN git config --global http.sslverify false
RUN git config --global pull.rebase false
RUN git config --global merge.ours.driver true

USER root

CMD [ "/usr/bin/supervisord" ]
