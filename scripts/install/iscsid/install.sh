#!/bin/bash
# OpenEBS需要的依赖
# 用于操作磁盘设备
set -e

yum -y install iscsi-initiator-utils
systemctl enable --now iscsid
