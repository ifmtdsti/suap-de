FROM carlosrabelo/suap-os:latest

ENV DEBIAN_FRONTEND=noninteractive

ENV LANG pt_BR.UTF-8
ENV LANGUAGE pt_BR:en
ENV LC_ALL pt_BR.UTF-8

RUN locale-gen pt_BR.UTF-8 && groupadd -g 1000 suap && useradd -rm -d /opt/suap -s /bin/bash -g suap -G sudo -u 1000 suap && echo 'suap:suap' | chpasswd

RUN apt-get --yes update && apt-get --yes install openssh-server && service ssh start

EXPOSE 22

ENTRYPOINT [ "/usr/sbin/sshd", "-D" ]
