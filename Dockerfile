FROM ifmt/suap-os:latest

ENV DEBIAN_FRONTEND=noninteractive

ENV LANG=pt_BR.UTF-8
ENV LANGUAGE=pt_BR:en
ENV LC_ALL=pt_BR.UTF-8

RUN locale-gen pt_BR.UTF-8

ADD ./lib/pip/base.txt /base.txt
ADD ./lib/pip/development.txt /development.txt

RUN \
    python -m pip install --upgrade pip && \
    python -m pip install setuptools==40.8.0 && \
    python -m pip install -r /development.txt && \
    rm /base.txt && \
    rm /development.txt

EXPOSE 8000
