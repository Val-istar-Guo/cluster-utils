#!/bin/bash
log "开始部署 istio..."
set -e

if [[ -z MANIFESTS_DIR ]]; then
  DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
  MANIFESTS_DIR=${DIR}/../../manifests
fi

helm repo add istio https://istio-release.storage.googleapis.com/charts
helm repo update

kubectl create namespace istio-system
helm install istio-base istio/base \
  -n istio-system

helm install istiod istio/istiod \
  -n istio-system \
  --values ${MANIFESTS_DIR}/istiod.helm.yaml

kubectl create namespace istio-ingress
kubectl label namespace istio-ingress istio-injection=enabled

log "部署 istio 完成"
