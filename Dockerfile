FROM ubuntu:14.04

RUN  apt-get install -y software-properties-common \
    && add-apt-repository -y ppa:saltstack/salt \
    && apt-get update \
    && apt-get install -y salt-minion \
    && apt-get install -y salt-master \
    && apt-get install -y salt-syndic

RUN mkdir -p /srv/salt/states

VOLUME ['/etc/salt/pki', '/var/cache/salt', '/var/logs/salt', '/etc/salt/master.d', '/srv/salt']

ADD ./master.d /etc/salt/master.d
ADD ./states /srv/salt/states

CMD ["salt-master", "-l", "debug", "-d"]
