FROM carlosrabelo/suap-os:18.04

RUN groupadd -g 1000 suap
RUN useradd -rm -d /workspace -s /bin/bash -g suap -G sudo -u 1000 suap

RUN echo 'suap:suap' | chpasswd

RUN service ssh start

EXPOSE 22

CMD ["/usr/sbin/sshd","-D"]
