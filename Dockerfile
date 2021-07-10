FROM carlosrabelo/suap-os:latest

RUN groupadd -g 1000 ifmt && useradd -rm -d /app -s /bin/bash -g ifmt -G sudo -u 1000 ifmt && echo 'ifmt:ifmt' | chpasswd && service ssh start

EXPOSE 22

CMD [ "/usr/sbin/sshd", "-D" ]
