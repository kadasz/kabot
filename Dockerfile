FROM phusion/baseimage:latest
MAINTAINER Karol D. Sz

ENV TZ "${TZ:-Europe/Warsaw}"
ENV APP kabot
ENV APP_PORT 8484
ENV APP_HOME /opt
ENV APP_REPO /var/www
ENV APP_USER www-data
ENV APP_CONF configuration.yaml

WORKDIR $APP_HOME

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update; apt-get -q -y --no-install-recommends install psmisc curl wget git less vim net-tools lsof iputils-ping iproute2 tzdata build-essential
RUN echo "deb http://ppa.launchpad.net/deadsnakes/ppa/ubuntu bionic main" | tee -a /etc/apt/sources.list.d/fkrull-deadsnakes.list
RUN echo "deb http://archive.ubuntu.com/ubuntu bionic main universe" | tee -a /etc/apt/sources.list
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv F23C5A6CF475977595C89F51BA6932366A755776
RUN apt-get update; apt-get -y --no-install-recommends install python3-pip python3-setuptools
RUN pip3 install --upgrade pip

# install opsdroid 
RUN pip3 install opsdroid

# cleanup
RUN apt-get autoremove -y; apt-get clean all
RUN rm -rf /root/.cache /tmp/* /var/tmp/* /var/lib/apt/lists/*; sync

# disable cron service
RUN touch /etc/service/cron/down
# remove sshd service and regenerate ssh keys
RUN rm -rf /etc/service/sshd /etc/my_init.d/00_regen_ssh_host_keys.sh

# copy configuration file
COPY $APP_CONF $APP_HOME

# runit - prepare opsdroid service
RUN mkdir -p /etc/service/$APP
COPY $APP.run /etc/service/$APP/run
RUN chmod +x /etc/service/$APP/run

# create directory for opsdroid skills repo
RUN mkdir -p $APP_REPO
# set permissions
RUN chown -R $APP_USER:$APP_USER $APP_HOME $APP_REPO

EXPOSE $APP_PORT
CMD ["/sbin/my_init"]
