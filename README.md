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
$ docker run --name rabbitmq-test -d seffeng/rabbitmq

# 例子：
$ docker run --name rabbitmq-alias1 -d seffeng/rabbitmq

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
$ docker run --name rabbitmq-alias1 --network network-01 --network-alias rabbitmq-alias1 -d seffeng/rabbitmq
```