#!/bin/bash
set -e
source ./bin/config.sh

isHelmCharInstalled prometheus && log "已安装 $APP_NAME" && exit

log "开始部署 $APP_NAME"

./add-repo.sh

#################################
# 如果Char包不存在则拉取
#################################
if [[ ! -d $DIR/kube-prometheus-stack ]]; then
  helm pull prometheus/kube-prometheus-stack --untar -d $DIR/
else
  log "$APP_NAME Char包已存在"
fi

#################################
# 安装Char包
#################################
if ! $(isHelmCharInstalled $APP_NAME); then
  if ! $(isK8sNsExisted $NAMESPACE); then
    kubectl create namespace $NAMESPACE
    # kubectl label namespace $NAMESPACE istio-injection=enabled
  fi

  helm install $APP_NAME $DIR/kube-prometheus-stack \
    -n $NAMESPACE \
    --values ./manifests/prometheus.helm.yaml
else
  log "$APP_NAME 已安装，请使用upgrade指令"
fi

log "$APP_NAME 部署完成"
