# Lua 脚本测试



## print / say

- `ngx.say` 自动添加换行符
- `ngx.print` 没有换行符

```nginx
location = /test/print {
  default_type 'text/plain';

  content_by_lua_block {
    ngx.print('Hello,world!')
  }
}

location = /test/say {
  default_type 'text/plain';

  content_by_lua_block {
    ngx.say('Hello,world!')
  }
}
```



## GET 请求参数

``` lua
location = /test/params {
  default_type 'text/plain';

  # /test/params?a=hello&a=world&a_b=hello world
  content_by_lua_block {
    
    -- 获取第一个参数
    ngx.say(ngx.var.args)
    ngx.say(ngx.var.arg_a)
    ngx.say(ngx.var.arg_a_b)
    ngx.say(ngx.unescape_uri(ngx.var.arg_a_b))

    ngx.say()
    
    -- 获取参数列表
    local args, err = ngx.req.get_uri_args()
    for key, val in pairs(args) do
        if type(val) == "table" then
            ngx.say(key, ": ", table.concat(val, ", "))
        else
            ngx.say(key, ": ", val)
        end
    end
  }
}
```

输出

```
a=hello&a=world&a_b=hello%20world
hello
hello%20world
hello world

a: hello, world
a_b: hello world
```



## POST 请求体

``` lua
# curl -X POST -d "Hello World 你好" http://localhost/test/request_body
location = /test/request_body {
  default_type 'text/plain';
  content_by_lua_block {
    -- 先读取 Body
    ngx.req.read_body()
    -- 再获取 Body
    local data = ngx.req.get_body_data()
    if data then
      ngx.say("body data:")
      ngx.print(data)
      return
    end

    -- body may get buffered in a temp file:
    local file = ngx.req.get_body_file()
    if file then
      ngx.say("body is in file ", file)
    else
      ngx.say("no body found")
    end
  }
}
```

## ngx.var

``` lua
-- /test/ngx_var?a=hello&b=word
location = /test/ngx_var {
  charset utf-8;
  default_type 'text/plain';

  content_by_lua_block {
    ngx.say()
    ngx.say("==== Nginx ====")
    ngx.say()
    ngx.say("ngx.var.status :", ngx.var.status)
    ngx.say("ngx.var.host :", ngx.var.host)
    ngx.say("ngx.var.hostname :", ngx.var.hostname)
    ngx.say("ngx.var.uri :", ngx.var.uri)
    ngx.say("ngx.var.request_uri :", ngx.var.request_uri)
    ngx.say("ngx.var.request :", ngx.var.request)
    ngx.say("ngx.var.content_type :", ngx.var.content_type)
    ngx.say()
    ngx.say("==== OpenResty ====")
    ngx.say()
    local reps_header, err = ngx.resp.get_headers()
    ngx.say(reps_header["content-type"])
    for k, v in pairs(reps_header) do
        ngx.say(k,":",v)
    end

  }
}
```



## 正则

``` lua
-- /test/regex?pattern=&text=
location = /test/regex {
  default_type 'text/plain';

  content_by_lua_block {
    ngx.say(ngx.var.arg_pattern)
    ngx.say(ngx.var.arg_text)
    ngx.say(ngx.unescape_uri(ngx.var.arg_text))
    
    local match, err = ngx.re.match(ngx.unescape_uri(ngx.var.arg_text),ngx.var.arg_pattern)
    if match then
      ngx.say(match[0])
    else
      if err then
        ngx.log(ngx.ERR, "error: ", err)
        return
      end

      ngx.say("match not found")
    end
  }
}
```



## 时间

``` lua
-- /test/time
location = /test/time {
  charset utf-8;
  default_type 'text/plain';

  content_by_lua_block {
    ngx.say("ngx.today() :", ngx.today())
    ngx.say("ngx.localtime() :", ngx.localtime())
    ngx.say("ngx.utctime() :", ngx.utctime())
    ngx.say()
    ngx.say("ngx.time() :", ngx.time())
    ngx.say("ngx.now() :", ngx.now())
    ngx.say()
    ngx.say("ngx.http_time(ngx.now()) :", ngx.http_time(ngx.now()))
    ngx.say("ngx.cookie_time(ngx.now()) :", ngx.cookie_time(ngx.now()))
    ngx.say("ngx.parse_http_time('Wed, 12-Aug-20 03:51:40 GMT') :", ngx.parse_http_time('Wed, 12-Aug-20 03:51:40 GMT'))
    ngx.say("ngx.today() :", ngx.today())
    ngx.say()
    ngx.say("ngx.now() :", ngx.now())
    ngx.say("sleep")
    ngx.sleep(0.01)
    ngx.say("ngx.now() :", ngx.now())
    ngx.say("sleep")
    ngx.sleep(0.01)
    ngx.say("ngx.update_time() 刷新时间")
    ngx.update_time()
    ngx.say("ngx.now() :", ngx.now())

    ngx.say("============ Lua 时间 ==========")
    ngx.say(os.date("%Y-%m-%d %H:%M:%S"))
  }
}
```





## 内部转发

``` nginx
location = /test/capture {
  default_type 'text/plain';

  content_by_lua_block {
    local res = ngx.location.capture("/test/say")
      if res then
        ngx.say("status: ", res.status)
      
        ngx.print("body:")
        ngx.say(res.body)
      end
  }
}
```





## 敏感信息校验（access_by_lua_*）

``` lua
location / {

  access_by_lua_block {
    -- 检查
    if ngx.var.remote_addr == "132.5.72.3" then
      ngx.exit(ngx.HTTP_FORBIDDEN)
    end

    -- 包含非法字符，重定向
    if ngx.var.uri and string.match(ngx.var.request_body, "evil") then
      return ngx.redirect("/terms_of_use.html")
    end
  }
  
  -- 校验通过
  content_by_lua_block {
    ngx.print("校验通过")
  }
}
```



## Read More

- [Nginx API for Lua](https://github.com/openresty/lua-nginx-module#nginx-api-for-lua)
- `for i in {1..100000}; do ./openresty -s reload; sleep 5; done`