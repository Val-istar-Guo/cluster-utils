#!/bin/bash
log "开始部署 cert-manager..."
set -e

if [[ -z MANIFESTS_DIR ]]; then
  DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
  MANIFESTS_DIR=${DIR}/../../manifests
fi

helm repo add jetstack https://charts.jetstack.io
helm repo update

helm install cert-manager jetstack/cert-manager \
  -n cert-manager \
  --create-namespace \
  --values ${MANIFESTS_DIR}/cert-manager.helm.yaml

kubectl apply -f ${MANIFESTS_DIR}/letsencrypt-issuer.yaml

log "部署 cert-manager 完成"
