#!/bin/bash
log "开始部署 openebs..."
set -e

if [[ -z MANIFESTS_DIR ]]; then
  DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
  MANIFESTS_DIR=${DIR}/../../manifests
fi

helm repo add openebs https://openebs.github.io/charts
helm repo update

helm install openebs openebs/openebs \
  --namespace openebs \
  --create-namespace \
  --values ${MANIFESTS_DIR}/openebs.helm.yaml

log "部署 openebs 完成"
