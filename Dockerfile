FROM proxysql/proxysql:2.0.8

MAINTAINER kien <nguyen.trung.kien@actindi.net>

RUN apt-get update && apt-get install -y \
    mysql-client \
    gettext-base \
 && rm -rf /var/lib/apt/lists/*
