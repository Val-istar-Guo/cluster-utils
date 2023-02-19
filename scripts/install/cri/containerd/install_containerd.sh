#!/bin/bash
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
set -e

# 检查是否已经安装
systemctl -q is-active containerd.service && log "containerd 已安装" && exit 0
log "安装 containerd..."

# 安装container
REPO=https://miaooo-users-service.oss-cn-shanghai.aliyuncs.com/containerd-1.6.16-linux-amd64.tar.gz
TEMP_FILEPATH=$(mktemp -t containerd-1.6.16-linux-amd64.XXXXXX.tar.gz)

wget -O ${TEMP_FILEPATH} ${REPO}
tar Cxzvf /usr/local ${TEMP_FILEPATH}

mkdir -p /usr/local/lib/systemd/system
wget -O /usr/local/lib/systemd/system/containerd.service https://ghproxy.com/raw.githubusercontent.com/containerd/containerd/main/containerd.service

systemctl daemon-reload
systemctl enable --now containerd

# 配置containerd
mkdir /etc/containerd
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

log "containerd 安装完成"
