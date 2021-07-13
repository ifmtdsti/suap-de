FROM carlosrabelo/suap-os:latest

RUN groupadd -g 1000 ifmt && useradd -rm -d /app -s /bin/bash -g ifmt -G sudo -u 1000 ifmt && echo 'ifmt:ifmt' | chpasswd && locale-gen pt_BR.UTF8 && service ssh start

ENV LANG pt_BR.UTF-8
ENV LANGUAGE pt_BR:en
ENV LC_ALL pt_BR.UTF-8

EXPOSE 22

CMD [ "/usr/sbin/sshd", "-D" ]
