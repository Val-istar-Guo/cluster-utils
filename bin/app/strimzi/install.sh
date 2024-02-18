#!/bin/bash
set -e

log "开始部署 strimzi..."

./add-repo.sh

if ! $(isHelmCharInstalled strimzi); then
  helm install strimzi strimzi/strimzi-kafka-operator \
    --namespace strimzi \
    --create-namespace \
    --values ./manifests/strimzi.helm.yaml
fi

log "strimzi 部署完成"
