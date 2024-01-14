#!/bin/bash
#################################
# OpenEBS需要的依赖 iscsid
# 用于操作磁盘设备
#################################
set -e
isServiceActive iscsid && log 'iscsid 已安装' && exit
log '安装 iscsid'

apt install -y open-iscsi
systemctl enable --now iscsid

# 完成
log 'iscsid 安装完成'
