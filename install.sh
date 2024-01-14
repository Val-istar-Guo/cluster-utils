#!/bin/bash
set -e

# 检查IP地址是否正确
function checkIP() {
  [[ -z $1 ]] && return 0
  [[ $1 =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]] && return 1

  echo "ERROR: $1 不符合IP地址格式，请重新输入"
  return 0
}

#################################
# 读取公网IP
#################################
if [[ -z $PUBLIC_IP ]]; then
  while (checkIP $PUBLIC_IP); do
    read -p "请输入公网IP：" PUBLIC_IP
  done
  echo "export PUBLIC_IP=$PUBLIC_IP" >>/etc/profile
  source /etc/profile
fi

#################################
# 安装Git
#################################
apt update
apt install -y git

#################################
# 克隆 cluster-utils
#################################
# REPO=https://mirror.ghproxy.com/https://github.com/Val-istar-Guo/cluster-utils
REPO=https://github.com/Val-istar-Guo/cluster-utils.git
DIR=$HOME/cluster-utils

[[ -e $DIR ]] && rm -rf $DIR

for i in {1..5}; do
  git clone ${REPO} ${DIR} && break || sleep 15
done

#################################
# 安装Kubernetes
#################################
cd $DIR && source bootstrap.sh && cd - >>/dev/null
