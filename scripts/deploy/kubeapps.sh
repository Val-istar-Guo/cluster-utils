#!/bin/bash
log "开始部署 kubeapps..."
set -e

if [[ -z MANIFESTS_DIR ]]; then
  DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
  MANIFESTS_DIR=${DIR}/../../manifests
fi

helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo update
helm install kubeapps bitnami/kubeapps \
  --namespace kubeapps \
  --create-namespace \
  --values ${MANIFESTS_DIR}/kubeapps.helm.yaml

# 开放NodePort(30090)访问
kubectl apply -f ${MANIFESTS_DIR}/kubeapps-svc.yaml

log "部署 kubeapps 完成"
