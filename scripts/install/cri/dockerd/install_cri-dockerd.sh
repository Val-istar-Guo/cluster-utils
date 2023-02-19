#!/bin/bash
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
set -e

systemctl -q is-active cri-docker.service && log "cri-docker 已安装" && exit 0
log "安装 cri-dockerd..."

INSTALL_DIR=/usr/local/cri-dockerd

# 清理上次安装的内容
[[ -d ${INSTALL_DIR} ]] && rm -rf ${INSTALL_DIR}

# 下载仓库
REPO=https://ghproxy.com/github.com/Mirantis/cri-dockerd.git
# REPO=https://gitclone.com/github.com/Mirantis/cri-dockerd.git
clone_repo ${REPO} ${INSTALL_DIR}

# Install Deps
cd ${INSTALL_DIR}
[ ! -d bin ] && mkdir bin
go get && go build -o bin/cri-dockerd

# Build cri-dockerd
[ ! -d /usr/local/bin ] && mkdir -p /usr/local/bin
install -o root -g root -m 0755 bin/cri-dockerd /usr/local/bin/cri-dockerd

cp -a packaging/systemd/* /etc/systemd/system

sed -i -e "/ExecStart/c\ExecStart=/usr/local/bin/cri-dockerd --container-runtime-endpoint fd:// --network-plugin=cni --pod-infra-container-image=${SANDBOX_IMAGE}" /etc/systemd/system/cri-docker.service

systemctl daemon-reload
systemctl enable cri-docker.service
systemctl enable --now cri-docker.socket
systemctl start cri-docker.service

cd -

log "cri-dockerd 安装完成"
