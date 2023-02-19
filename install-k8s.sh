#!/bin/bash
set -e

#################################
# 公网部署必须设定IP
#################################
if [ -z "${PUBLIC_IP}" ]; then
  read -p "请输入公网IP：" PUBLIC_IP

  if [[ ! $PUBLIC_IP =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]]; then
    echo "ERROR: 非法IP"
    exit
  fi

  echo "export PUBLIC_IP=${PUBLIC_IP}" >>/etc/profile
  source /etc/profile
fi

#################################
# 克隆 cluster-utils
#################################
# REPO=https://ghproxy.com/https://github.com/Val-istar-Guo/cluster-utils
REPO=https://github.com/Val-istar-Guo/cluster-utils.git
DIR=$(basename ${REPO} .git)

cd $HOME
for i in {1..5}; do
  if [[ -d ${DIR} ]]; then
    echo "${DIR}仓库已克隆"
    break
  else
    git clone ${REPO} && break
  fi

  sleep 15
done

cd ${DIR}

#################################
# 安装Kubernetes
#################################
source ./bootstrap.sh
