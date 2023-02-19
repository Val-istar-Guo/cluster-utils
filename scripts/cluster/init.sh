#!/bin/bash
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
read_public_ip $@

set -e

log '初始化K8s控制面板'
# 使用docker
# cri-dockerd
# kubeadm init \
#   --apiserver-advertise-address=${PUBLIC_IP} \
#   --control-plane-endpoint=${PUBLIC_IP} \
#   --image-repository=registry.aliyuncs.com/google_containers \
#   --cri-socket=unix:///var/run/cri-dockerd.sock \
#   --service-cidr=10.96.0.0/12 \
#   --pod-network-cidr=10.244.0.0/16 \

kubeadm init \
  --apiserver-advertise-address=${PUBLIC_IP} \
  --control-plane-endpoint=${PUBLIC_IP} \
  --image-repository=${IMAGE_REPOSITORY} \
  --service-cidr=10.96.0.0/12 \
  --pod-network-cidr=10.244.0.0/16

log '创建kubectl配置'
mkdir -p $HOME/.kube
cp -f /etc/kubernetes/admin.conf $HOME/.kube/config
chown $(id -u):$(id -g) $HOME/.kube/config

${DIR}/../deploy/kube-flannel.sh
${DIR}/../install/helm/install.sh
