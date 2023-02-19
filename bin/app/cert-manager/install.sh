#!/bin/bash
set -e

log "开始部署 cert-manager..."

./add-repo.sh

if ! $(isHelmCharInstalled cert-manager); then
  helm install cert-manager cert-manager/cert-manager \
    -n cert-manager \
    --create-namespace \
    --values ./cert-manager.helm.yaml
fi

#################################
# 添加 Let's Encrypt CA 供应商
#################################
kubectl apply -f ./letsencrypt-issuer.yaml

log "部署 cert-manager 完成"
