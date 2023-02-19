#!/bin/bash
set -e

HELM_REPO=https://istio-release.storage.googleapis.com/charts

if ! $(isHelmRepoExisted istio $HELM_REPO); then
  helm repo add istio $HELM_REPO
  helm repo update istio
else
  log 'Helm 仓库已存在'
fi
