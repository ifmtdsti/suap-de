FROM ifmt/suap-os:latest

ENV DEBIAN_FRONTEND=noninteractive

ENV LANG=pt_BR.UTF-8
ENV LANGUAGE=pt_BR:en
ENV LC_ALL=pt_BR.UTF-8

RUN locale-gen pt_BR.UTF-8

COPY requirements.txt /requirements.txt

RUN pip install -r /requirements.txt

EXPOSE 8000
