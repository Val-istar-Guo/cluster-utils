#!/bin/bash
source ./bin/exports.sh
source ./bin/function.sh
set -e

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
# 开始安装
#################################
cd ./bin/bootstrap
./iscsid.sh
./runc.sh
./containerd.sh
./kubernetes.sh
./helm.sh
cd - >>/dev/null

#################################
# 需要开启 cgroups cpu
# 重启系统后生效
#################################
echo 'GRUB_CMDLINE_LINUX="cgroup_enable=cpu"' >>/etc/default/grub
log "系统重启"
reboot
