#!/bin/bash
set -e

log "开始部署 openebs..."

./add-repo.sh

if ! $(isHelmCharInstalled openebs); then
  helm install openebs openebs/openebs \
    --namespace openebs \
    --create-namespace \
    --values ./manifests/openebs.helm.yaml
fi

kubectl apply -f ./manifests/jiva-volumn-policy.yaml
kubectl apply -f ./manifests/jiva-storage-class.yaml

log "openebs 部署完成"
