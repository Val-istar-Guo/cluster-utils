#!/bin/bash

#################################
# 国内的kubernetes启动需要的容器的镜像仓库
#################################
export IMAGE_REGISTRY="registry.aliyuncs.com/google_containers"

#################################
# 国内kubernetes的沙盒容器镜像地址
#################################
export SANDBOX_IMAGE="${IMAGE_REGISTRY}/pause:3.7"

#################################
# 部署app的数据文件存储位置
#################################
export CHARS=${HOME}/chars
mkdir -p $CHARS
