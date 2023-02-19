#!/bin/bash
set -e

# kubeadm reset -f --cri-socket=unix:///var/run/cri-dockerd.sock
kubeadm reset -f
