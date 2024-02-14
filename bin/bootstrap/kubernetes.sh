#!/bin/bash
set -e

#################################
# 转发IPv4并让iptables看到桥接流量
#################################
log '配置iptables'
cat <<EOF | tee /etc/modules-load.d/k8s.conf
overlay
br_netfilter
EOF

modprobe overlay
modprobe br_netfilter

# 设置所需的 sysctl 参数，参数在重新启动后保持不变
cat <<EOF | tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-iptables  = 1
net.bridge.bridge-nf-call-ip6tables = 1
net.ipv4.ip_forward                 = 1
EOF

# 应用 sysctl 参数而不重新启动
sysctl --system

#################################
# 禁用交换分区
#################################
log "禁用交换分区"
sed -i '/ swap / s/^(.*)$/#1/g' /etc/fstab
swapoff -a

#################################
# 创建一个虚拟网卡
# 由于阿里云/腾讯云的服务器并没有绑定公网IP的网卡
# Debian12使用systemd-network管理网络
# 与Debian11的networking配置方式不一样
#################################
if ! ip addr | grep -wq ${PUBLIC_IP}; then
  log '创建公网IP的虚拟网卡...'

  cat >/etc/network/interfaces.d/ifcfg-eth0:1 <<EOF
auto eth0:1
iface eth0:1 inet static
address ${PUBLIC_IP}
netmask 255.255.255.0
EOF

  systemctl restart networking
fi

#################################
# 同步时钟时间
#################################
log '同步时钟'
apt install -y ntpdate
ntpdate time.windows.com

#################################
# 安装kubernetes
#################################
# 检查是否已经安装
isServiceActive kubelet && log "kubernetes 已安装" && exit
log '安装 kubernetes...'

mkdir -p /etc/apt/sources.list.d
# 连续两个tac避免 curl(23) Failed writing body 错误
curl https://mirrors.aliyun.com/kubernetes/apt/doc/apt-key.gpg | tac | tac | apt-key add -
cat <<EOF >/etc/apt/sources.list.d/kubernetes.list
deb https://mirrors.aliyun.com/kubernetes/apt/ kubernetes-xenial main
EOF

# 设置清华源
# 清华源在国外无法使用可以更换为阿里源
# 国外可用gpg
# curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | tac | tac | apt-key add -
# https://mirrors.tuna.tsinghua.edu.cn/help/kubernetes/
# cat >/etc/apt/sources.list.d/kubernetes.list <<EOF
# deb https://mirrors.tuna.tsinghua.edu.cn/kubernetes/apt/ kubernetes-xenial main
# EOF

# 安装
apt-get update
apt-get install -y apt-transport-https ca-certificates curl
apt-get install -y kubelet=1.28.2-00 kubeadm=1.28.2-00 kubectl=1.28.2-00
apt-mark hold kubelet kubeadm kubectl

systemctl enable --now kubelet

# 修改sandbox镜像
cat >/etc/default/kubelet <<EOF
KUBELET_EXTRA_ARGS="--cgroup-driver=systemd --pod-infra-container-image=${SANDBOX_IMAGE}"
EOF

# 使用公网IP
sed -i "/ExecStart=.\+/{
  s/ --node-ip=$//
  s/$/ --node-ip=${PUBLIC_IP}/
}" /etc/systemd/system/kubelet.service.d/10-kubeadm.conf

systemctl daemon-reload
systemctl restart kubelet

# 完成
log 'kubernetes 安装完成'
