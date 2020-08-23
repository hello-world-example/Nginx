# Resty-Cli

该指令在 OpenResty 安装后自带，用来测试运行在 OpenResty 中的脚本

```bash
$ ll /usr/local/openresty/bin/resty*

/usr/local/openresty/bin/resty
/usr/local/openresty/bin/restydoc
/usr/local/openresty/bin/restydoc-index
```



## resty

- `-e` 执行脚本语句
- `xxx.lua` 执行 lua 文件
- `-V` 查看版本
- 
- `--shdict='dogs 1m'` 指定共享变量

```bash
# 单行
$ ./bin/resty -e "ngx.say('hello')"

# 多行
$ ./bin/resty -e "                 
local name = 'World'
ngx.say('Hello '..name)
"


# 执行 Nginx API Lua 文件
$ ./bin/resty /etc/nginx/conf.d/lua/unit_test_regex.lua 

# 共享字典
$ ./bin/resty --shdict='dogs 1m' \
              -e 'local dict = ngx.shared.dogs
                  print(dict:get("Tom"))
                  dict:set("Tom", 56)
                  print(dict:get("Tom"))'
```



## restydoc

查看 指令&API 帮助文档

```bash
$ ./bin/restydoc -s ngx.say
   ngx.say
       syntax: ok, err = ngx.say(...)

       context: rewrite_by_lua*, access_by_lua*, content_by_lua*

       Just as ngx.print but also emit a trailing newline.




$ ./bin/restydoc -s content_by_lua
   content_by_lua_block
       syntax: content_by_lua_block { lua-script }

       context: location, location if

       phase: content

       Similar to the content_by_lua directive except that this directive
       inlines the Lua source directly inside a pair of curly braces ("{}")
       instead of in an NGINX string literal (which requires special character
       escaping).

       For instance,

            content_by_lua_block {
                ngx.say("I need no extra escaping here, for example: \r\nblah")
            }

       This directive was first introduced in the "v0.9.17" release.
```





## Read More

- [OpenResty® RPM Packages](https://openresty.org/en/rpm-packages.html)
- [openresty / resty-cli](https://github.com/openresty/resty-cli)