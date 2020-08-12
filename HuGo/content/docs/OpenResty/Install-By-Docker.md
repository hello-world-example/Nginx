# Docker 方式安装



## 安装

``` bash
$ docker pull openresty/openresty:1.11.2.1-centos

$ docker run -d \
	-p 80:80 \
  --name openresty \
  -v /private/docker/volumes/openresty/conf.d:/etc/nginx/conf.d \
  -v /private/docker/volumes/openresty/logs:/etc/nginx/logs \
  openresty/openresty:1.11.2.1-centos
  

# docker exec -it openresty bash
# cd /usr/local/openresty/nginx/

# docker kill openresty 
# docker rm openresty
# docker ps -a | grep openresty
```



## /etc/nginx/conf.d/

进入 `/private/docker/volumes/openresty/conf.d` 新增 一下两个文件，文件内容是从 `nginx.conf` 中截取的

### default.conf

```nginx
server {

    listen       80 default_server reuseport;
    server_name  localhost;

    #charset koi8-r;

    #access_log  logs/host.access.log  main;

    location = / {
        root   html;
        index  index.html index.htm;
    }

    #error_page  404              /404.html;

    # redirect server error pages to the static page /50x.html
    #
    error_page   500 502 503 504  /50x.html;
    location = /50x.html {
        root   html;
    }

    # proxy the PHP scripts to Apache listening on 127.0.0.1:80
    #
    #location ~ \.php$ {
    #    proxy_pass   http://127.0.0.1;
    #}

    # pass the PHP scripts to FastCGI server listening on 127.0.0.1:9000
    #
    #location ~ \.php$ {
    #    root           html;
    #    fastcgi_pass   127.0.0.1:9000;
    #    fastcgi_index  index.php;
    #    fastcgi_param  SCRIPT_FILENAME  /scripts$fastcgi_script_name;
    #    include        fastcgi_params;
    #}

    # deny access to .htaccess files, if Apache's document root
    # concurs with nginx's one
    #
    #location ~ /\.ht {
    #    deny  all;
    #}

    include /etc/nginx/conf.d/location.d/*.conf;
}

```

### https.conf

```nginx
# HTTPS server
#
#server {
#    listen       443 ssl;
#    server_name  localhost;

#    ssl_certificate      cert.pem;
#    ssl_certificate_key  cert.key;

#    ssl_session_cache    shared:SSL:1m;
#    ssl_session_timeout  5m;

#    ssl_ciphers  HIGH:!aNULL:!MD5;
#    ssl_prefer_server_ciphers  on;

#    location / {
#        root   html;
#        index  index.html index.htm;
#    }
#}

```



### 修改 nginx.conf

```bash
$ docker exec -it openresty bash

$ cd /usr/local/openresty/nginx/
$ vi conf/nginx.conf
#  
# 删除所有 server 节点，（在 http 节点下）新增以下 include 语句
include /etc/nginx/conf.d/*.conf;


# 校验 配置文件是否出错
$ ./sbin/nginx -t
nginx: the configuration file /usr/local/openresty/nginx/conf/nginx.conf syntax is ok
nginx: configuration file /usr/local/openresty/nginx/conf/nginx.conf test is successful

# 重新加载 配置文件
$ ./sbin/nginx -s reload
```







## /etc/nginx/conf.d/location.d/

- `/etc/nginx/conf.d/`  下创建 `location.d/` 文件夹
-  `location.d/` 文件夹下 新增 `lua_index.conf` 文件，内容如下
- `./sbin/nginx -s reload`
- curl http://localhost/lua/， 输出 `hello, world`

```nginx
location ~ /lua/ {
  default_type text/html;
  content_by_lua_block {
      ngx.say("<p>hello, world</p>")
  }
}
```



## Read More

- Docker Hub [docker-openresty - Docker tooling for OpenResty](https://hub.docker.com/r/openresty/openresty)
- Github [openresty / docker-openresty](https://github.com/openresty/docker-openresty)
  - https://github.com/openresty/docker-openresty/tree/1.11.2.1

