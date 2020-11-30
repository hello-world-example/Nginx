# Kong Docker 方式安装



## 数据库模式

### 创建 network

```bash
$ docker network ls
$ docker network prune

$ docker network create kong-net
```



### Postgres 安装

```bash
$ docker run -d \
  --network=kong-net \
  -p 5432:5432 \
  -e "POSTGRES_DB=postgres" \
  -e "POSTGRES_USER=kong" \
  -e "POSTGRES_PASSWORD=kong" \
  --name kong-database \
  postgres:9.6.15
```



### 初始化 Postgres

```bash
$ docker run --rm \
		--network=kong-net \
     -e "KONG_PG_HOST=kong-database" \
     -e "KONG_PG_PORT=5432" \
     -e "KONG_PG_USER=kong" \
     -e "KONG_PG_PASSWORD=kong" \
     -e "KONG_PG_DATABASE=postgres" \
     -e "KONG_PG_SCHEMA=kong" \
     kong:2.1.4-centos kong migrations bootstrap
```



### 启动 Kong

```bash
$ docker run -d --name kong \
     --network=kong-net \
     -e "KONG_PG_HOST=kong-database" \
 		 -e "KONG_PG_PORT=5432" \
     -e "KONG_PG_USER=kong" \
     -e "KONG_PG_PASSWORD=kong" \
     -e "KONG_PG_DATABASE=postgres" \
     -e "KONG_PG_SCHEMA=kong" \
     -e "KONG_PROXY_ACCESS_LOG=/dev/stdout" \
     -e "KONG_ADMIN_ACCESS_LOG=/dev/stdout" \
     -e "KONG_PROXY_ERROR_LOG=/dev/stderr" \
     -e "KONG_ADMIN_ERROR_LOG=/dev/stderr" \
     -e "KONG_PROXY_LISTEN=0.0.0.0:8000, 0.0.0.0:8443 ssl" \
     -e "KONG_ADMIN_LISTEN=0.0.0.0:8001, 0.0.0.0:8444 ssl" \
     -v /private/docker/volumes/kong/etc/kong/:/etc/kong/ \
     -p 80:8000 \
     -p 8001:8001 \
     kong:2.1.4-centos

$ curl https://raw.githubusercontent.com/Kong/kong/master/kong.conf.default > \
	/private/docker/volumes/kong/etc/kong/kong.conf
```



## 配置文件模式

> [DB-less mode](https://docs.konghq.com/install/docker/)
>
> [DB-less and Declarative Configuration](https://docs.konghq.com/2.2.x/db-less-and-declarative-config/)



## 端口

- `:8000` HTTP upstream 监听端口

- `:8443` HTTPs upstream 监听端口

  

- `:8001` HTTP [Admin API](https://docs.konghq.com/2.2.x/admin-api) 管理端口

- `:8444` HTTPs [Admin API](https://docs.konghq.com/2.2.x/admin-api) 管理端口



## Read More

- [Kong Gateway Docker Installation](https://docs.konghq.com/install/docker/)