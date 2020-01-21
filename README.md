
## ProxySQL With MySQL Client

### Run

```sh
$ docker run -d \
-p 16032:6032 \
-p 16033:6033 \
-v /path/to/proxysql.cnf:/etc/proxysql.cnf \
${image name}
```


