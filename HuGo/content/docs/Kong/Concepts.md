# Kong 核心概念



## 模块层级

- **RESTful APIs**
  - Admin API 接口等
- **Plugins**
  - 基于 Lua 开发，类似于拦截器
  - 提供多用场景的插件
  - 官方插件市场：https://docs.konghq.com/hub/
- **集群 & 数据存储**
  - 支持 Postgres、Cassandra
- **OpenResty**
  - Kong 的底层引擎
  - 通过 lua 指令 提供请求生命周期的 Hooks
- **Nginx**



## 功能概念

![来源：https://docs.konghq.com/getting-started-guide/latest/overview/](https://docs.konghq.com/assets/images/docs/getting-started-guide/Kong-GS-overview.png)



- **Route**：
  - 定义匹配规则：Host、Header、Path 等
  - 与 Service 绑定，匹配的每个请求都将代理到其关联的 Service 上

- **Services**
  - 服务的抽象，通过 url 与 upstream 或 IP 进行关联

- **Upstreams**
  - 同 Nginx 概念，服务实例的集合
- **Target**
  - 反向代理的目标地址
  - 与 Upstreams 关联

- **Consumer**
  - 服务调用者
- **Plugins**
  - HTTP 请求/响应 生命周期中执行逻辑



## 配置一个服务

> - [Configuring a Service](https://docs.konghq.com/latest/getting-started/configuring-a-service/)



### Services

> 该服务会儿会被转发到：http://github.com

```bash
$ curl -i -X POST \
  --url http://localhost:8001/services/ \
  --data 'name=service_github' \
  --data 'url=http://github.com'
```



### Route

> Route 规则与服务 service_github 绑定，这里如果 Hosts 是 github.kail.xyz，则会被转发到 http://github.com

```bash
$ curl -i -X POST \
  --url http://localhost:8001/services/service_github/routes \
  --data 'hosts[]=github.kail.xyz'
```



### 访问

```bash
$ curl -i --header "Host: github.kail.xyz" http://localhost/
```





### Upstreams 完整示例

```bash
# 创建 Upstreams
$ curl -i -X POST \
  --url http://localhost:8001/upstreams/ \
  --data 'name=upstream_baidu_and_bing' 
  
# 增加两个 负载目标1
$ curl -i -X POST \
  --url http://localhost:8001/upstreams/upstream_baidu_and_bing/targets \
  --data 'target=www.baidu.com:80'

# 增加两个 负载目标2
$ curl -i -X POST \
  --url http://localhost:8001/upstreams/upstream_baidu_and_bing/targets \
  --data 'target=bing.cn:80'

# 创建服务
$ curl -i -X POST \
  --url http://localhost:8001/services/ \
  --data 'name=service_baidu_and_bing' \
  --data 'host=upstream_baidu_and_bing'

# 绑定 Route
$ curl -i -X POST \
  --url http://localhost:8001/services/service_baidu_and_bing/routes \
  --data 'hosts[]=baidu_and_bing.com'

# 多次访问查看效果
$ curl -i --header "Host: baidu_and_bing.com" http://localhost/
```



### 相关 Admin API

- **Service Object**
- [Add Service](https://docs.konghq.com/2.2.x/admin-api/#add-service)
  - [Update Service](https://docs.konghq.com/2.2.x/admin-api/#update-service)
- **Route Object**
  - [Add Route](https://docs.konghq.com/2.2.x/admin-api/#add-route)
  - [Update Route](https://docs.konghq.com/2.2.x/admin-api/#update-route)
- **Upstream Object**
  - [Add Upstream](https://docs.konghq.com/2.2.x/admin-api/#add-upstream)
- **Target Object**
  - [Add Target](https://docs.konghq.com/2.2.x/admin-api/#add-target)



## Read More

- [Kong Getting Started Guide](https://docs.konghq.com/getting-started-guide/latest/overview/)
- [Kong 网关工作原理及核心概念](https://www.lyafei.com/archives/236/)
- [kong 配置 upstream 实现简单的负载均衡](https://www.cnblogs.com/sunhongleibibi/p/12035508.html)