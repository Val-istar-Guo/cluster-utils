#!/bin/bash
set -e

HELM_REPO=https://openebs.github.io/charts

if ! $(isHelmRepoExisted openebs $HELM_REPO); then
  helm repo add openebs $HELM_REPO
  helm repo update openebs
else
  log 'Helm 仓库已存在'
fi
