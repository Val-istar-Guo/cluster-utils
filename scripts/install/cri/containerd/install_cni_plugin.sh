#!/bin/bash
set -e

log '安装 cni plugin...'
# REPO=https://ghproxy.com/github.com/containernetworking/plugins/releases/download/v1.2.0/cni-plugins-linux-amd64-v1.2.0.tgz
REPO=https://miaooo-users-service.oss-cn-shanghai.aliyuncs.com/cni-plugins-linux-amd64-v1.2.0.tgz
TEMP_FILEPATH=$(mktemp -t cni-plugins-linux-amd64-v1.2.0.XXXXXX.tgz)

wget -O ${TEMP_FILEPATH} ${REPO}
mkdir -p /opt/cni/bin
tar Cxzvf /opt/cni/bin ${TEMP_FILEPATH}

log 'cni plugin 安装完成'
