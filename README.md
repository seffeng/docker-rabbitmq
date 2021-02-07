# Docker Alpine RabbitMQ

## 环境

```
alpine: ^3.12
rabbitmq: 3.8.11
```

## 常用命令：

```sh
# 拉取镜像
$ docker pull seffeng/rabbitmq

# 运行
$ docker run --name rabbitmq-test -d -p 5672:5672 -p 15672:15672 -v <tmp-dir>:/opt/websrv/tmp -v <log-dir>:/opt/websrv/logs seffeng/rabbitmq

# 例子：
$ docker run --name rabbitmq-alias1 -d -p 5672:5672 -p 15672:15672 -v /opt/websrv/tmp:/opt/websrv/tmp -v /opt/websrv/logs/rabbitmq:/opt/websrv/logs seffeng/rabbitmq

# 查看正在运行的容器
$ docker ps

# 停止
$ docker stop [CONTAINER ID | NAMES]

# 启动
$ docker start [CONTAINER ID | NAMES]

# 进入终端
$ docker exec -it [CONTAINER ID | NAMES] sh

# 删除容器
$ docker rm [CONTAINER ID | NAMES]

# 镜像列表查看
$ docker images

# 删除镜像
$ docker rmi [IMAGE ID]
```
#### 备注

```shell
# 建议容器之间使用网络互通
## 1、添加网络[已存在则跳过此步骤]
$ docker network create network-01

## 运行容器增加 --network network-01 --network-alias [name-net-alias]
$ docker run --name rabbitmq-alias1 --hostname rabbitmq-alias1 --network network-01 --network-alias rabbitmq-net1 -d -p 5672:5672 -p 15672:15672 -v /opt/websrv/tmp:/opt/websrv/tmp -v /opt/websrv/logs/rabbitmq:/opt/websrv/logs seffeng/rabbitmq

# 登入容器创建新用户
$ docker exec -it rabbitmq-alias1 sh

## 创建新用户
$ rabbitmqctl add_user {username} {password}

## 设置新用户权限
$ rabbitmqctl set_permissions -p / {username} ".*" ".*" ".*"
$ rabbitmqctl set_user_tags {username} administrator

# 集群配置
## 1、新增 RabbitMQ 节点
$ docker run --name rabbitmq-alias2 --hostname rabbitmq-alias2 --network network-01 --network-alias rabbitmq-net2 -d -v /opt/websrv/tmp:/opt/websrv/tmp -v /opt/websrv/logs/rabbitmq:/opt/websrv/logs seffeng/rabbitmq

## 2、修改 cookie 文件与 rabbitmq-alias1 一致，查看 rabbitmq-alias1 的cookie
$ docker exec -it rabbitmq-alias2 sh
$ echo "rabbitmq-alias1.cookie" > /root/.erlang.cookie
### 退出容器 rabbitmq-alias2，重启 rabbitmq-server 服务
$ docker restart rabbitmq-alias2

## 3、增加节点，登入容器 rabbitmq-alias2
$ docker exec -it rabbitmq-alias2 sh
$ rabbitmqctl stop_app
$ rabbitmqctl join_cluster rabbit@rabbitmq-alias1
$ rabbitmqctl start_app

## 注意：hostname 需能 ping 通，如果使用非容器名,请增加容器 hosts 配置
```