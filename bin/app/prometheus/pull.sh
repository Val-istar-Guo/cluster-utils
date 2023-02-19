#!/bin/bash
set -e
source ./bin/config.sh

cd $DIR
[[ -d kube-prometheus-stack.backup ]] && rm -rf kube-prometheus-stack.backup
[[ -d kube-prometheus-stack ]] && mv kube-prometheus-stack kube-prometheus-stack.backup
helm pull prometheus/kube-prometheus-stack --untar $@
cd - >>/dev/null
