ARG PROXYSQL_VERSION="2.0.17"
FROM ubuntu:latest

ARG PROXYSQL_VERSION
LABEL author="actindi Inc."
LABEL maintainer="actindi Inc. <dev@actindi.net>"
LABEL proxysql="${PROXYSQL_VERSION}"
LABEL description="ProxySQL with tools."

RUN apt-get update && \
    apt-get install -y wget mysql-client gettext-base && \
    rm -rf /var/lib/apt/lists/*

RUN wget https://github.com/sysown/proxysql/releases/download/v${PROXYSQL_VERSION}/proxysql_${PROXYSQL_VERSION}-ubuntu20_amd64.deb && \
    dpkg -i proxysql_${PROXYSQL_VERSION}-ubuntu20_amd64.deb && \
    rm proxysql_${PROXYSQL_VERSION}-ubuntu20_amd64.deb

EXPOSE 6032 6033

CMD ["proxysql", "-f"]
