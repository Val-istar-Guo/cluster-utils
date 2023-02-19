#!/bin/bash
set -e

#################################
# 读取服务器IP
#################################
while (checkIP $PUBLIC_IP); do
  read -p "请输入公网IP：" PUBLIC_IP
done
echo "export PUBLIC_IP=$PUBLIC_IP" >>/etc/profile
source /etc/profile

read -p "请输入 Control Plane Endpoint：" CONTROL_PLANE_ENDPOINT

#################################
# 初始化K8s控制面板
#################################
log '初始化K8s控制面板'

kubeadm init \
  --apiserver-advertise-address=$PUBLIC_IP \
  --control-plane-endpoint=$CONTROL_PLANE_ENDPOINT \
  --image-repository=$IMAGE_REGISTRY \
  --service-cidr=10.96.0.0/12 \
  --pod-network-cidr=10.244.0.0/16 \
  --upload-certs

#################################
# 添加kubectl配置
#################################
log '添加kubectl配置'
mkdir -p $HOME/.kube
cp -f /etc/kubernetes/admin.conf $HOME/.kube/config
chown $(id -u):$(id -g) $HOME/.kube/config

#################################
# 安装完成
#################################
log 'kubernetes 初始化完成'
