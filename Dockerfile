FROM phusion/baseimage:latest
MAINTAINER Karol D Sz

ENV TZ Europe/Warsaw

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update; apt-get -q -y --no-install-recommends install psmisc curl wget git less vim net-tools lsof iputils-ping iproute2 tzdata build-essential
RUN echo "deb http://ppa.launchpad.net/deadsnakes/ppa/ubuntu bionic main" | tee -a /etc/apt/sources.list.d/fkrull-deadsnakes.list
RUN echo "deb http://archive.ubuntu.com/ubuntu bionic main universe" | tee -a /etc/apt/sources.list
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv F23C5A6CF475977595C89F51BA6932366A755776
#RUN apt-get update; apt-get -y --no-install-recommends install libpython3.7-stdlib python3.7-minimal $PY_VERSION
RUN apt-get update; apt-get -y --no-install-recommends install python3-pip python3-setuptools
RUN pip3 install --upgrade pip
#RUN curl https://bootstrap.pypa.io/get-pip.py | $PY_VERSION -

#RUN rm -f /usr/bin/python && ln -s /usr/bin/$APP_VERSION /usr/bin/python
#RUN rm -f /usr/bin/python3 && ln -s /usr/bin/$APP_VERSION /usr/bin/python3
RUN pip3 install opsdroid

RUN apt-get clean
RUN rm -rf /tmp/* /var/tmp/* /var/lib/apt/lists/*

WORKDIR /opt
CMD ["/sbin/my_init"]
