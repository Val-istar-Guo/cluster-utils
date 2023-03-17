#!/bin/bash
set -e

# kubeadm reset -f --cri-socket=unix:///var/run/cri-dockerd.sock
kubeadm reset -f

systemctl stop kubelet
rm -rf /var/lib/cni/*
rm -rf /var/lib/kubelet/*
rm -rf /etc/cni/*
ifconfig cni0 down
ifconfig flannel.1 down
ip link delete cni0
ip link delete flannel.1
systemctl start kubelet
