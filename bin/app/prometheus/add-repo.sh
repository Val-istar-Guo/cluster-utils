#!/bin/bash
set -e
source ./bin/config.sh

if ! $(isHelmRepoExisted $APP_NAME $HELM_REPO); then
  log "添加 Helm 仓库 $APP_NAME"
  helm repo add $APP_NAME $HELM_REPO
  helm repo update $APP_NAME
  log "已添加 Helm 仓库 $APP_NAME"
else
  log "已存在 Helm 仓库 $APP_NAME"
fi
