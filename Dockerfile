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

COPY lib/etc/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

USER suap

WORKDIR /app

ADD --chown=suap:suap lib/bin/bash_aliases.sh .bash_aliases
ADD --chown=suap:suap lib/bin/bashrc.sh       .bashrc
ADD --chown=suap:suap lib/bin/profile.sh      .profile

RUN git config --global http.sslverify false && \
    git config --global pull.rebase false && \
    git config --global merge.ours.driver true

RUN code-server --install-extension ms-python.python && \
    code-server --install-extension ms-toolsai.jupyter && \
    code-server --install-extension genuitecllc.codetogether

USER root

CMD [ "/usr/bin/supervisord" ]
