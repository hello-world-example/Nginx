# 反向代理



## Simple 配置

```nginx
server {
  server_name  www.kail.com;
  location / {
    proxy_pass  http://localhost:8080;
  }
}

server {
  server_name  api.kail.com;
  location / {
    proxy_pass  http://localhost:8888;
  }
}
```



```nginx
upstream lb {
  
  server 192.168.1.1;
  server 192.168.1.2;

  # 设置权重，默认是 1
  server backend1.example.com      weight=5;
  # 失败最大重试次数（默认 1），与 fail_timeout (默认 10s) 属性组合使用
  server 192.0.2.1                 max_fails=3  fail_timeout=30s;
}

server {
  server_name  lb.kail.com;
  location / {
    proxy_pass http://lb;
  }
}
```







## Read More

- ngx_http_proxy_module
  - [proxy_pass](http://nginx.org/en/docs/http/ngx_http_proxy_module.html#proxy_pass) 
- ngx_http_upstream_module
  - [upstream](http://nginx.org/en/docs/http/ngx_http_upstream_module.html#upstream) 、 [server](http://nginx.org/en/docs/http/ngx_http_upstream_module.html#server) 、 [keepalive](http://nginx.org/en/docs/http/ngx_http_upstream_module.html#keepalive) 、[keepalive_timeout](http://nginx.org/en/docs/http/ngx_http_upstream_module.html#keepalive_timeout) 
- [Using nginx as HTTP load balancer](http://nginx.org/en/docs/http/load_balancing.html)