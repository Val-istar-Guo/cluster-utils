#!/bin/bash
set -e

[ -x "$(command -v helm)" ] && log "Helm($(helm version --short)) 已安装" && exit 0

log "开始安装 helm ..."
# REPO="https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3"
# REPO="https://mirror.ghproxy.com/raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3"
# curl ${REPO} | bash

REPO="https://miaooo-users-service.oss-cn-shanghai.aliyuncs.com/helm-v3.11.0-linux-amd64.tar.gz"
TEMP_DIR=$(mktemp -t -d helm.XXXXXX)
TEMP_FILE=$(mktemp -t helm-v3.11.0-linux-amd64.XXXXXX.tgz)

wget -O ${TEMP_FILE} ${REPO}

tar -zxvf ${TEMP_FILE} -C ${TEMP_DIR}
mv ${TEMP_DIR}/linux-amd64/helm /usr/local/bin/helm

# 基于https://github.com/Val-istar-Guo/dotfiles
# 开启helm命令自动补全功能
mkdir -p ${HOME}/.dotfiles/zsh
helm completion zsh >${HOME}/.dotfiles/zsh/helm

log 'helm 安装完成'
