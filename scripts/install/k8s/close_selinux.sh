#!/bin/bash

log '关闭 selinux...'

sed -i --follow-symlinks 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/sysconfig/selinux
[[ $(sestatus) == *enabled ]] && setenforce 0

log 'selinux 已关闭'
