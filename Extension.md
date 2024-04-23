# 扩展功能

## 创建进程

```json
POST /program/create/{name}

{
    # 保留为空
    "ConfigDir": "",
    # 保留为空
    "Group": "",
    # 建议和URL中的name一致
    "Name": "HTTPSERVER",
    "KeyValues": {
        # 启动命令，建议使用绝对路径，建议通过脚本包装，参数通过环境变量或者命令行参数传入
        "command": "/tools/httpserver.py",
        # 环境变量，格式：KEY="val",KEY2="val2" 
        "environment": "",
        # 是否自动启动，默认true
        "autostart": "true",
        # 是否自动重启，unexpected(默认) true false
        "autorestart": "unexpected",
        # autorestart为unexpected时如果退出码不在exitcodes中则重启，默认0,2
        "exitcodes":"0",
        # 用shell等方式启动时会创建子进程，需要按进程组停止
        "stopasgroup":"true",
        # 工作目录
        "directory":"",
        # 是否一次性任务，自定义的key，默认false
        # 为true时不保存进程配置，适用于单次执行任务
        "oneshot":"true"
    }
}
```

```bash
curl -X POST -H "Content-Type: application/json" http://localhost:9001/program/create/HttpServer --data "$(cat << EOF
{
    "ConfigDir": "",
    "Group": "",
    "Name": "HttpServer",
    "KeyValues": {
        "command": "python3 -m http.server",
        "environment": "",
        "autostart": "true",
        "autorestart": "unexpected",
        "exitcodes":"0",
        "stopasgroup":"true",
        "directory":"",
        "oneshot":"true"
    }
}
EOF
)"
```

## 撤销进程

```json
POST /program/revoke/{name}
```

```bash
curl -X POST  http://localhost:9001/program/revoke/HttpServer
```

## 说明

- 远程创建的进程，其他配置保存在supervisord.d/目录下，名称为{name}.cfg，name需要全局唯一，否则会覆盖同名进程

- oneshot为自定义添加的key，用于一次性任务，该进程的配置不保存，如果supervisord重启，不会启动该进程


## TODO

- 没有统一维护进程配置，只管理了远程创建的进程，不能撤销配置文件中的进程，除非按远程进程的方式存放配置
