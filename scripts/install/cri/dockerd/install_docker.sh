#!/bin/bash
set -e

[ -x "$(command -v docker)" ] && log "Docker($(docker version -f '{{.Server.Version}}')) 已安装" && exit 0
log "安装 Docker..."

yum install -y yum-utils
yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
yum install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin

systemctl enable --now docker
systemctl start docker

cat <<EOF >/etc/docker/daemon.json
{
  "exec-opts": ["native.cgroupdriver=systemd"]
}
EOF

systemctl daemon-reload
systemctl restart docker

log "Docker($(docker version -f '{{.Server.Version}}')) 安装完成"
