# Kong Admin UI



## pantsel/konga

```bash
# 初始化数据
$ docker run --rm -e "DB_PG_SCHEMA=konga" pantsel/konga:0.14.9 \
    -c prepare \
    -a postgres \
    -u postgresql://kong:kong@10.10.16.160:5432/postgres

# 运行
$ docker run -d \
    -p 1337:1337 \
    -e "NODE_ENV=production" \
    -e "TOKEN_SECRET=konga" \
    -e "DB_ADAPTER=postgres" \
    -e "DB_HOST=10.10.16.160" \
    -e "DB_PORT=5432" \
    -e "DB_USER=kong" \
    -e "DB_PASSWORD=kong" \
    -e "DB_DATABASE=postgres" \
    -e "DB_PG_SCHEMA=konga"\
    --name konga \
    pantsel/konga:0.14.9
```



## PGBI/kong-dashboard

> 注意：不支持最新版的 kong

```bash
$ docker run -d \
		-p 8008:8080 \
		--name kong-dashboard \
		pgbi/kong-dashboard:v3.5.0 start \
			--kong-url http://10.10.16.160:8001 \
			--basic-auth kong=kong
```





## Read More

- [pantsel/konga](https://github.com/pantsel/konga)
- [PGBI/kong-dashboard](https://github.com/PGBI/kong-dashboard)