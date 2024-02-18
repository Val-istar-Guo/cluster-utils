#!/bin/bash
set -e

HELM_REPO=https://strimzi.io/charts/

if ! $(isHelmRepoExisted strimzi $HELM_REPO); then
  helm repo add strimzi $HELM_REPO
  helm repo update strimzi
else
  log 'Helm 仓库已存在'
fi
