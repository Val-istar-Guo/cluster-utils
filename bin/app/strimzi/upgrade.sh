#!/bin/bash
set -e

log "开始升级 strimzi..."

helm upgrade strimzi strimzi/strimzi-kafka-operator \
  --namespace strimzi \
  --values ./strimzi.helm.yaml

[[ -n MANIFESTS ]] && cp ./strimzi.helm.yaml $MANIFESTS/

log "升级 strimzi 完成"
