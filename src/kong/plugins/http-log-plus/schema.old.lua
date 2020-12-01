-- https://docs.konghq.com/0.14.x/plugin-development/plugin-configuration/#table-of-contents
return {
    name = "http-log-plus",
    fields = {
        http_endpoint = { type = "string", required = true },
        method = { type = "string", default = "POST", one_of = { "POST", "PUT", "PATCH" }, },
        content_type = { type = "string", default = "application/json", one_of = { "application/json" }, },
        timeout = { type = "number", default = 10000 },
        keepalive = { type = "number", default = 60000 },
        retry_count = { type = "integer", default = 10 },
        queue_size = { type = "integer", default = 1 },
        flush_timeout = { type = "number", default = 2 },
        -- 扩展配置
        plus_request_body = { type = "boolean", default = false },
        plus_response_body = { type = "boolean", default = false },
        plus_response_content_type_pattern_include = { type = "string", default = nil },
        plus_response_content_type_pattern_exclude = { type = "string", default = nil },
    },
}