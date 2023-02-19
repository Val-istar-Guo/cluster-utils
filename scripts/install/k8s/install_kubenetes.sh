log '安装 kubelet,kubeadm,kubectl...'

# 清华源
cat >/etc/yum.repos.d/kubernetes.repo <<EOF
[kubernetes]
name=kubernetes
baseurl=https://mirrors.tuna.tsinghua.edu.cn/kubernetes/yum/repos/kubernetes-el7-x86_64
enabled=1
EOF

# 阿里云源
# cat > /etc/yum.repos.d/kubernetes.repo <<EOF
# [kubernetes]
# name=Kubernetes
# baseurl=https://mirrors.aliyun.com/kubernetes/yum/repos/kubernetes-el7-x86_64/
# enabled=1
# gpgcheck=1
# repo_gpgcheck=1
# gpgkey=https://mirrors.aliyun.com/kubernetes/yum/doc/yum-key.gpg https://mirrors.aliyun.com/kubernetes/yum/doc/rpm-package-key.gpg
# EOF

yum install -y --nogpgcheck kubelet kubeadm kubectl
systemctl enable kubelet
systemctl start kubelet

cat >/etc/sysconfig/kubelet <<EOF
KUBELET_EXTRA_ARGS="--cgroup-driver=systemd --pod-infra-container-image=${SANDBOX_IMAGE}"
EOF

sed -i "/ExecStart=.\+/{
  s/ --node-ip=$//
  s/$/ --node-ip=${PUBLIC_IP}/
}" /usr/lib/systemd/system/kubelet.service.d/10-kubeadm.conf

systemctl daemon-reload
systemctl restart kubelet

log 'kubelet,kubeadm,kubectl 安装完成'
