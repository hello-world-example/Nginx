package = "kong-plugin-http-log-plus"
version = "2.0.1-1"
supported_platforms = {"linux", "macosx"}
source = {
  url = "git://github.com/makcy/kong-http-log-extended",
  tag = "v1.0"
}
description = {
  summary = "Add Request & Response Body log options in http-log",
  license = "MIT",
  homepage = "https://github.com/makcy/kong-plugin-http-log-extended",
}
dependencies = {
  "lua ~> 5.1"
}
build = {
  type = "builtin",
  modules = {
    ["kong.plugins.http-log-plus.handler"] = "handler.lua",
    ["kong.plugins.http-log-plus.schema"] = "schema.lua",
    -- 扩展
    ["kong.plugins.http-log-plus.log_plus"] = "log_plus.lua",
    ["kong.plugins.http-log-plus.log_plus_base"] = "log_plus_base.lua",
    -- 兼容
    ["kong.plugins.http-log-plus.batch_queue"] = "batch_queue.lua"
  }
}