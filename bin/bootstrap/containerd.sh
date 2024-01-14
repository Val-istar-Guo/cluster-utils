#!/bin/bash
set -e

#################################
# 安装cri/containerd
#################################

# 检查是否已经安装
isServiceActive containerd && log "containerd 已安装" && exit 0
log "安装 containerd..."

# 参数检查
[[ -z $SANDBOX_IMAGE ]] && log '请设置 SANDBOX_IMAGE' && exit

# 配置项
REPO=https://miaooo-users-service.oss-cn-shanghai.aliyuncs.com/containerd-1.6.16-linux-amd64.tar.gz
TEMP=$(mktemp -t containerd-1.6.16-linux-amd64.XXXXXX.tar.gz)

# 安装container
wget -O ${TEMP} ${REPO}
tar xzvf ${TEMP} -C /usr/local

mkdir -p /usr/local/lib/systemd/system
wget -O /usr/local/lib/systemd/system/containerd.service https://mirror.ghproxy.com/raw.githubusercontent.com/containerd/containerd/main/containerd.service

systemctl daemon-reload
systemctl enable --now containerd

# 修改sandbox镜像源
# 修改k8s启动必要的containerd配置项
mkdir -p /etc/containerd
containerd config default >/etc/containerd/config.toml

sed -i \
  -e "/sandbox_image/c\    sandbox_image = \"${SANDBOX_IMAGE}\"" \
  -e 's|config_path\ =.*|config_path = \"\/etc\/containerd\/certs.d\"|g' \
  -e 's/SystemdCgroup\ =\ false/SystemdCgroup\ =\ true/g' \
  /etc/containerd/config.toml

## 添加docker镜像源
mkdir -p /etc/containerd/certs.d/docker.io
cat >/etc/containerd/certs.d/docker.io/hosts.toml <<EOF
server = "https://docker.io"
[host."https://registry-1.docker.io"]
  capabilities = ["pull", "resolve"]
EOF

systemctl daemon-reload
systemctl restart containerd

# 结束
log "containerd 安装完成"

#################################
# 安装 containerd/cni-plugins
#################################
log '安装 containerd cni plugin...'

# 配置项
# REPO=https://mirror.ghproxy.com/github.com/containernetworking/plugins/releases/download/v1.2.0/cni-plugins-linux-amd64-v1.2.0.tgz
REPO=https://miaooo-users-service.oss-cn-shanghai.aliyuncs.com/cni-plugins-linux-amd64-v1.2.0.tgz
TEMP=$(mktemp -t cni-plugins-linux-amd64-v1.2.0.XXXXXX.tgz)

# 安装
wget -O ${TEMP} ${REPO}
mkdir -p /opt/cni/bin
tar xzvf ${TEMP} -C /opt/cni/bin

# 完成
log 'cni plugin 安装完成'
