# 指令与生命周期



## 执行顺序

![指令执行顺序图](https://cloud.githubusercontent.com/assets/2137369/15272097/77d1c09e-1a37-11e6-97ef-d9767035fc3e.png)



## 脚本类指令

| 指令                                |             Context             |                阶段                 | 简介                                                         | 作用                                                 |
| :---------------------------------- | :-----------------------------: | :---------------------------------: | ------------------------------------------------------------ | ---------------------------------------------------- |
| `init_by_lua*`                      |              http               |           loading-config            | 主进程加载配置文件时执行                                     | 预加载模块、等<br />！不要创建全局变量，避免变量污染 |
| `init_worker_by_lua*`               |              http               |           starting-worker           | 每个 Worker 进程启动时执行                                   | Worker 计数器、等                                    |
| ----------------------------------- |         --------------          | ----------------------------------- | -----------------------------------                          | -----------------------------------                  |
| `ssl_certificate_by_lua_*`          |             server              |     right-before-SSL-handshake      | 与下游 SSL 握手之前执行                                      |                                                      |
| `ssl_session_fetch_by_lua_*`        |              http               |     right-before-SSL-handshake      | 根据下游提供的 sessionid 进行一些操作                        | 缓存、等                                             |
| `ssl_session_store_by_lua_*`        |              http               |      right-after-SSL-handshake      | SSL 握手之后执行                                             |                                                      |
| ----------------------------------- |         --------------          | ----------------------------------- | -----------------------------------                          | -----------------------------------                  |
| `set_by_lua*`                       |      server<br />location       |               rewrite               | 定义变量                                                     | 实现复杂的赋值逻辑<br />阻塞执行，代码要做到非常快   |
| ❤ `rewrite_by_lua*`                 | http<br />server<br />location  |            rewrite tail             | rewrite 之后<br />`rewrite_by_lua_no_postpone`   可修改执行顺序 | 地址重定向<br /> URL 重写                            |
| ❤ `access_by_lua*`                  | http<br />server<br />location  |             access tail             | `access_by_lua_no_postpone` 可修改执行顺序                   | 拦截，访问控制、等                                   |
| ----------------------------------- |         --------------          | ----------------------------------- | -----------------------------------                          | -----------------------------------                  |
| ❤ **`content_by_lua*`**             |            location             |               content               | 生成响应内容                                                 | 不要和其他内容指令一起使用 如 `proxy_pass`           |
| `balancer_by_lua_*`                 |            upstream             |               content               | 负载均衡时                                                   | 动态负载均衡                                         |
| ----------------------------------- |         --------------          | ----------------------------------- | -----------------------------------                          | -----------------------------------                  |
| `header_filter_by_lua*`             | http<br />server<br /> location |        output-header-filter         | 代理响应后                                                   | 获取/修改 响应 Header                                |
| ❤ **`body_filter_by_lua*`**         | http<br />server<br />location  |         output-body-filter          | 代理响应后                                                   | 获取/修改 响应 Body<br />一次请求中可能会调用多次    |
| ----------------------------------- |         --------------          | ----------------------------------- | -----------------------------------                          | -----------------------------------                  |
| `log_by_lua*`                       | http<br />server<br />location  |                 log                 | 日志之前执行                                                 | 记录、统计 访问等                                    |
| ----------------------------------- |         --------------          | ----------------------------------- | -----------------------------------                          | -----------------------------------                  |
| `exit_worker_by_lua_*`              |              http               |           exiting-worker            | 每个 Worker 进程退出时执行                                   | 释放资源等                                           |



## 配置类指令

| 指令                              | Default | Context | 简介                                                         |
| --------------------------------- | :-----: | :-----: | ------------------------------------------------------------ |
| 【已废弃】~~lua_load_resty_core~~ |         |         | v0.10.16 后 `resty.core` 强制加载                            |
| lua_capture_error_log             |  none   |  http   | 缓存错误日志，而不是保存到磁盘中<br />如果缓存满了，新的错误日志将覆盖缓存中日志 |
| lua_use_default_type              | on | http,server,location |                                                              |
| lua_malloc_trim                   | 1000 | http | 多少次请求清理一次内存 |
| **lua_code_cache**  | on | http,server,location | 是否开启 `*_by_lua_file` 缓存<br />如果关闭，每个请求都会在单独的 Lua VM 实例中执行 |
| lua_regex_cache_max_entries | 1024 | http | 正则表达式缓存的最大数量，如 `ngx.re.*` 中的正则 |
| lua_regex_match_limit             | 0 | http | 正则表达式库 PCRE 的 回溯限制数量 |
| **lua_package_path**              | LUA_PATH | http | Lua 文件搜索路径 |
| **lua_package_cpath**             | LUA_CPATH | http | Lua C 模块搜索路径 |
| **lua_need_request_body**         | off | http,server,location | 是否强制读取请求体，可以在需要时通过 `ngx.req.read_body()` 读取 |
|**lua_shared_dict**| no | http | 定义共享字典，通过 `ngx.shared.DICT` 操作 |
||  |  |  |
|lua_socket_connect_timeout| 60s | http,server,location | scoket connect 方法超时时间 |
|lua_socket_send_timeout| 60s | http,server,location | scoket send 方法超时时间 |
|lua_socket_send_lowat| 0 | http,server,location | cosocket send buffer 的 lowwater |
|lua_socket_read_timeout| 60s | http,server,location | scoket receive 方法超时 |
|lua_socket_buffer_size| 4k/8k | http,server,location | cosocket 读取操作的缓冲区大小 |
|lua_socket_pool_size| 30 | http,server,location | cosocket 链接池大小 |
|lua_socket_keepalive_timeout| 60s | http,server,location | cosocket 链接池中链接的最大超时时间 |
|lua_socket_log_errors| on | http,server,location | cosockets 是否记录错误日志 |
||  |  | |
|lua_ssl_ciphers| DEFAULT | http,server,location |  |
|lua_ssl_crl| no | http,server,location |  |
|lua_ssl_protocols| SSLv3 TLSv1 TLSv1.1 TLSv1.2 | http,server,location |  |
|lua_ssl_trusted_certificate| no | http,server,location |  |
|lua_ssl_verify_depth| 1 | http,server,location |  |
|| | | |
|lua_http10_buffering| on | http,server,location | 是否启用HTTP1.0 里的缓冲机制，仅是为了兼容HTTP 1.0/0.9 协议 |
|lua_transform_underscores_in_response_headers| on | http,server,location | 是否把Lua代码里响应头名字的“_”转换成“-” |
|lua_check_client_abort| off | http,server,location | 是否启用OpenResty的客户端意外断连检测 |
|lua_max_pending_timers| 1024 | http | 允许挂起的最大计数器个数<br />`ngx.timer.at` 设置定时器 |
|lua_max_running_timers| 256 | http | 允许运行的最大计数器个数<br />`ngx.timer.at` 设置定时器 |
|lua_sa_restart| on | http |  |



## Read More

- [lua-nginx-module Directives](https://github.com/openresty/lua-nginx-module#directives)
- [[code.openresty] Openresty指令集-上](https://www.jianshu.com/p/8e0877d69b39)
- [[code.openresty] Openresty指令集-下](https://www.jianshu.com/p/5d0c4ce39a26)