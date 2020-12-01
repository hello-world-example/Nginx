---
--- 【该文件用于本地调试，实际使用请使用】实际使用请使用：
--- luarocks make kong-plugin-http-log-plus-2.0.1-1.rockspec
--- luarocks make kong-plugin-http-log-plus-old-1.rockspec
---
--- cp http-log-plus/*.lua /private/docker/volumes/kong/plugins/http-log-plus
--- docker restart kong
--- docker logs kong -f --tail=50
---
local log_plus_new = require "kong.plugins.http-log-plus.log_plus_new"

local _M = {}

function _M.access(ngx, conf)
    log_plus_new.access(ngx, conf)
end

function _M.body_filter(ngx, conf)
    log_plus_new.body_filter(ngx, conf)
end

function _M.log_plus(kong, ngx, conf)
    return log_plus_new.log_plus(kong, ngx, conf)
end

return _M