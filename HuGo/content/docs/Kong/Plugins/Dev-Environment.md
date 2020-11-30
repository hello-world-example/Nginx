# 开发环境搭建

> **背景：**
>
> - [Lua 快速开始](/Lua/docs/Quick-Start/Quick-Start/)
> - [LuaRocks 安装](/Lua/docs/LuaRocks/LuaRocks-Install/)
> - [创建一个 Rock](/Lua/docs/LuaRocks/Creating-Rock/)
>
> **准备**
>
> - [Kong Docker 方式安装](/Nginx/docs/Kong/Install-By-Docker/)



## Docker 方式

> - 在 [Kong Docker 方式安装](/Nginx/docs/Kong/Install-By-Docker/) 的基础上，
> - 增加 volume 映射 `/usr/local/share/lua/5.1/kong/plugins/debug-plugin` 插件目录
> - `debug-plugin` 可替换为真实的插件名

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
     -v /private/docker/volumes/kong/plugins/debug-plugin/:/usr/local/share/lua/5.1/kong/plugins/debug-plugin \
     -p 80:8000 \
     -p 8001:8001 \
     kong:2.1.4-centos

# 下载默认配置
$ curl https://raw.githubusercontent.com/Kong/kong/master/kong.conf.default > \
	/private/docker/volumes/kong/etc/kong/kong.conf
	
# 找到 plugins = bundled 打开注释，增加 debug-plugin 插件
$ vim /private/docker/volumes/kong/etc/kong/kong.conf
plugins = bundled, debug-plugin

# 拷贝插件到 /private/docker/volumes/kong/plugins/debug-plugin
$ cp *.lua /private/docker/volumes/kong/plugins/debug-plugin

# 重启 kong
$ docker restart kong
```



## FAQ

### docker logs kong 发现报错的插件不存在

- 原因：kong 容器销毁重新生成，但是数据库的记录仍然是之前的
- 打开 kong 所在的 postgres 数据库
- 删除 `plugins` 表中 插件所在的行
- `docker restart kong` 重启



## Read More

- [Kong插件开发向导](https://www.jianshu.com/p/abef41d85ec4)
- [Kong插件开发工具包](https://www.jianshu.com/p/bf7f7bfb0639)