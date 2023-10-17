ARG PROXYSQL_VERSION="2.0.17"
FROM proxysql/proxysql:${PROXYSQL_VERSION}

ARG PROXYSQL_VERSION
LABEL auther="actindi Inc."
LABEL maintainer="actindi Inc. <dev@actindi.net>"
LABEL proxysql="${PROXYSQL_VERSION}"
LABEL description="ProxySQL with tools."

RUN apt-get update && apt-get install -y \
    mysql-client \
    gettext-base \
 && rm -rf /var/lib/apt/lists/*
