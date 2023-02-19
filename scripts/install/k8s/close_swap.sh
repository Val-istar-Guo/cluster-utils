#!/bin/bash

log '关闭 swap分区'
sed -i '/ swap / s/^(.*)$/#1/g' /etc/fstab
swapoff -a
