# 静态资源



## 参考配置

```nginx
server {

  listen       80 default_server reuseport;
  server_name  localhost;
  charset      utf8;
  error_page   404  /404.html;

  location / {
    # 指定实际录绝对路径
    root   /etc/nginx/conf.d/html/;
    # 默认首页
    index  index.html index.htm;
    
    # 开启目录浏览功能
    autoindex on;
    # 开启详细文件大小统计，让文件大小显示 MB，GB单位，默认为 b
    autoindex_exact_size off; 
    # 以服务器本地时区显示文件修改日期
    autoindex_localtime on; 
  }

}
```



## Read More

- [Serving Static Content](http://nginx.org/en/docs/beginners_guide.html#static)
- ngx_http_core_module
  - [server](http://nginx.org/en/docs/http/ngx_http_core_module.html#server) 、 [listen](http://nginx.org/en/docs/http/ngx_http_core_module.html#listen) 、 [server_name](http://nginx.org/en/docs/http/ngx_http_core_module.html#server_name) 、[error_page](http://nginx.org/en/docs/http/ngx_http_core_module.html#error_page) 、  [location](http://nginx.org/en/docs/http/ngx_http_core_module.html#location) 、 [root](http://nginx.org/en/docs/http/ngx_http_core_module.html#root) 、[alias](http://nginx.org/en/docs/http/ngx_http_core_module.html#alias) 、 
- ngx_http_charset_module
  - [charset](http://nginx.org/en/docs/http/ngx_http_charset_module.html#charset) 
- ngx_http_index_module
  -  [index](http://nginx.org/en/docs/http/ngx_http_index_module.html#index)
- ngx_http_autoindex_module
  -  [autoindex](http://nginx.org/en/docs/http/ngx_http_autoindex_module.html#autoindex) 、 [autoindex_exact_size](http://nginx.org/en/docs/http/ngx_http_autoindex_module.html#autoindex_exact_size) 、[autoindex_format](http://nginx.org/en/docs/http/ngx_http_autoindex_module.html#autoindex_format) 、 [autoindex_localtime](http://nginx.org/en/docs/http/ngx_http_autoindex_module.html#autoindex_localtime)

