
## install

``` bash
# kong 2.0.1+
luarocks make kong-plugin-http-log-plus-2.0.1-1.rockspec
# kong 2.0.1-
# luarocks make kong-plugin-http-log-plus-old-1.rockspec

重启 kong

curl 'http://localhost:8001/plugins/schema/http-log-plus'
{
    "name":"http-log-plus",
    "fields":{
        "plus_response_content_type_pattern_exclude":{
            "type":"string"
        },
        "retry_count":{
            "type":"integer",
            "default":10
        },
        "timeout":{
            "type":"number",
            "default":10000
        },
        "plus_response_body":{
            "type":"boolean",
            "default":false
        },
        "plus_request_body":{
            "type":"boolean",
            "default":false
        },
        "method":{
            "type":"string",
            "one_of":[
                "POST",
                "PUT",
                "PATCH"
            ],
            "default":"POST"
        },
        "content_type":{
            "type":"string",
            "one_of":[
                "application/json"
            ],
            "default":"application/json"
        },
        "plus_response_content_type_pattern_include":{
            "type":"string"
        },
        "queue_size":{
            "type":"integer",
            "default":1
        },
        "http_endpoint":{
            "type":"string",
            "required":true
        },
        "keepalive":{
            "type":"number",
            "default":60000
        },
        "flush_timeout":{
            "type":"number",
            "default":2
        }
    }
}
```