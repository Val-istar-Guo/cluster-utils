#!/bin/bash
set -e

log "开始升级 openebs..."

helm upgrade openebs openebs/openebs \
  --namespace openebs \
  --values ./openebs.helm.yaml

[[ -n MANIFESTS ]] && cp ./openebs.helm.yaml $MANIFESTS/

log "升级 openebs 完成"
