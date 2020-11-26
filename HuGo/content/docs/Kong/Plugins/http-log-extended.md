# http-log-extended



- 该插件相比官方插件 [http-log](https://docs.konghq.com/hub/kong-inc/http-log/)
- 增加了对 `requestBody` 和 `responseBody` 的输出
- 便于分析 请求体 和 响应信息，但是日志量会较大



## 安装插件

```bash
$ git clone https://github.com/Makcy/kong-plugin-http-log-extended.git

$ cd kong-plugin-http-log-extended

# 安装
$ luarocks make

# 查看安装位置
$ cat `luarocks config --system-config`
..
rocks_trees = {
   { name = "user", root = home .. "/.luarocks" };
   { name = "system", root = "/usr/local" };
}
..
$ ll /usr/local"/share/lua/5.1"/kong/plugins/http-log-extended/

# 修改 kong.conf
$ vim /etc/kong/kong.conf
# 老版
custom_plugins = http-log-extended
# 新版
plugins = bundled, http-log-extended

# 重启 kong 生效
$ kong stop && kong start

# 查看所有可用的插件
$ curl http://localhost:8001/plugins/enabled
```



## 删除插件

```bash
# 修改 kong.conf，删除插件配置
$ vim /etc/kong/kong.conf

# 卸载插件文件
$ luarocks remove kong-plugin-http-log-extended

# 重启 kong 生效
$ kong stop && kong start
```



## FAQ





## Read More

- [Makcy / kong-plugin-http-log-extended](https://github.com/Makcy/kong-plugin-http-log-extended)