#!/bin/bash
set -e

#################################
# 安装 oci/runc
#################################
log "安装 oci/runc"

# REPO=https://mirror.ghproxy.com/github.com/opencontainers/runc/releases/download/v1.1.4/runc.amd64
REPO=https://miaooo-users-service.oss-cn-shanghai.aliyuncs.com/runc.amd64
TEMP_FILEPATH=$(mktemp -t runc.amd64.XXXXXX)

wget -O ${TEMP_FILEPATH} $REPO
install -m 755 ${TEMP_FILEPATH} /usr/local/sbin/runc
