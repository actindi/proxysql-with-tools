
## Overview

[Official ProxySQL Docker Images](https://hub.docker.com/r/proxysql/proxysql)

Official ProxySQL Docker Images doesn't contain the MySQL Client, so I added it.
In addition, `envsubst` is also included so that environment variables can be embedded in the configuration file for general use.

## Run

### Run ProxySQL container with a custom configuration file
```sh
$ docker run -d \
-p 16032:6032 \
-p 16033:6033 \
-v /path/to/proxysql.cnf:/etc/proxysql.cnf \
ghcr.io/actindi/proxysql-with-tools:latest
```

### Setting ProxySQL with environment variables 
```sh
$ docker run -d \
-p 16032:6032 \
-p 16033:6033 \
-v /path/to/proxysql-cnf.template:/var/lib/proxysql/proxysql-cnf.template \
-e WRITER_HOST=hoge \
-e READER_HOST=hoge \
-e MYSQL_USER=hoge \
-e MYSQL_PASSWORD=hoge \
-e READ_ONLY_CHECK_TYPE=read_only \
--entrypoint /bin/sh \
ghcr.io/actindi/proxysql-with-tools:latest \
-c "envsubst < /var/lib/proxysql/proxysql-cnf.template > /etc/proxysql.cnf && cat /etc/proxysql.cnf && proxysql -f -D /var/lib/proxysql"
```

### Sample proxysql-cnf.template file (i.e. `/path/to/proxysql-cnf.template` listed above)

```
datadir="/var/lib/proxysql"
errorlog="/var/lib/proxysql/proxysql.log"

admin_variables=
{
  admin_credentials="admin:admin;"
  web_enabled=true
}

mysql_variables=
{
  connect_timeout_server=3000
  monitor_username="${MYSQL_USER}"
  monitor_password="${MYSQL_PASSWORD}"
  monitor_history=600000
  monitor_connect_interval=60000
  monitor_ping_interval=10000
  monitor_read_only_interval=1500
  monitor_read_only_timeout=1000
  ping_timeout_server=500
}


# defines all the MySQL servers
mysql_servers =
(
  {
    address = "${WRITER_HOST}"
    port = 3306
    hostgroup = 1
    weight = 1
  },
  {
    address = "${WRITER_HOST}"
    port = 3306
    hostgroup = 2
    weight = 1
  },
  {
    address = "${READER_HOST}"
    port = 3306
    hostgroup = 2
    weight = 1
  },
)


# defines all the MySQL users
mysql_users:
(
  {
    username = "${MYSQL_USER}"
    password = "${MYSQL_PASSWORD}"
    default_hostgroup = 1
  },
)

#defines MySQL Query Rules
mysql_query_rules:
(
  {
    rule_id = 1
    active = 1
    match_digest = "^SELECT .* FOR UPDATE$"
    destination_hostgroup = 1
    apply = 1
  },
  {
    rule_id = 2
    active = 1
    match_digest = "^SELECT"
    destination_hostgroup = 2
    apply = 1
  }
)

mysql_replication_hostgroups=
(
  {
    writer_hostgroup = 1
    reader_hostgroup = 2
    check_type = "${READ_ONLY_CHECK_TYPE}"
  }
)
```