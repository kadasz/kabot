FROM phusion/baseimage:latest
MAINTAINER Karol D. Sz

ENV TZ Europe/Warsaw
ENV APP_PORT 8484
ENV APP_HOME /opt
ENV APP_CONF configuration.yaml

WORKDIR $APP_HOME

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update; apt-get -q -y --no-install-recommends install psmisc curl wget git less vim net-tools lsof iputils-ping iproute2 tzdata build-essential
RUN echo "deb http://ppa.launchpad.net/deadsnakes/ppa/ubuntu bionic main" | tee -a /etc/apt/sources.list.d/fkrull-deadsnakes.list
RUN echo "deb http://archive.ubuntu.com/ubuntu bionic main universe" | tee -a /etc/apt/sources.list
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv F23C5A6CF475977595C89F51BA6932366A755776
RUN apt-get update; apt-get -y --no-install-recommends install python3-pip python3-setuptools
RUN pip3 install --upgrade pip

RUN pip3 install opsdroid

# cleanup
RUN apt-get autoremove -y; apt-get clean all
RUN rm -rf /root/.cache /tmp/* /var/tmp/* /var/lib/apt/lists/*; sync

# disable cron service
RUN touch /etc/service/cron/down
# remove sshd service and regenerate ssh keys
RUN rm -rf /etc/service/sshd /etc/my_init.d/00_regen_ssh_host_keys.sh

COPY $APP_CONF $APP_HOME

CMD ["/sbin/my_init"]
