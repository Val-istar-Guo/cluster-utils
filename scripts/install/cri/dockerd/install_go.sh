#!/bin/bash
set -e

[ -x "$(command -v go)" ] && log "Go($(go version)) 已安装" && exit 0
log "安装 Go..."

wget https://studygolang.com/dl/golang/go1.18.7.linux-amd64.tar.gz
tar -C /usr/local -xzf go1.18.7.linux-amd64.tar.gz
rm -rf go1.18.7.linux-amd64.tar.gz

cat >>/etc/bashrc <<EOF
# 设置GO安装目录
export GOROOT=/usr/local/go
export PATH=\$PATH:\$GOROOT/bin
export GOPATH=/root/go
export PATH=\$PATH:\$GOPATH/BIN
export GO111MODULE=on
export GOPROXY=https://goproxy.cn
EOF

source /etc/bashrc

log "Go($(go version)) 安装完成"
