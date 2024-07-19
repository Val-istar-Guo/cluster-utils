#!/bin/bash
set -e

log "开始升级 istio..."

helm upgrade istiod istio/istiod \
  --namespace istio-system \
  --values ./manifests/istiod.helm.yaml

log "升级 istio 完成"
