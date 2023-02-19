#!/bin/bash
set -e

log "开始部署 kubeapps..."

helm repo add bitnami https://charts.bitnami.com/bitnami
helm install kubeapps bitnami/kubeapps \
  -n kubeapps \
  --create-namespace \
  --values ./kubeapps.helm.yaml

#################################
# 开放30090端口
#################################
kubectl apply -f ./kubeapps-svc.yaml

[[ -n $MANIFESTS ]] && cp ./kubeapps.helm.yaml $MANIFESTS/ && cp ./kubeapps-svc.yaml $MANIFESTS/

log "部署 kubeapps 完成"
