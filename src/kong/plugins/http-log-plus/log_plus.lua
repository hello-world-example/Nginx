---
--- 【该文件用于本地调试，实际使用请使用】实际使用请使用：
--- luarocks make kong-plugin-http-log-plus-2.0.1-1.rockspec
--- luarocks make kong-plugin-http-log-plus-old-1.rockspec
---
--- cp http-log-plus/*.lua /private/docker/volumes/kong/plugins/http-log-plus
--- docker restart kong
--- docker logs kong -f --tail=50
---
local LogPlus = require "kong.plugins.http-log-plus.log_plus_base"

local _M = LogPlus:extend()

function _M:new ()
end

function _M.log_plus(kong, ngx, conf)
    local KongLog = kong.log.serialize()
    return _M.super.log_plus(KongLog, ngx, conf)
end

return _M