#!/bin/bash
source ./bin/config.sh

helm upgrade $APP_NAME $DIR/kube-prometheus-stack \
  -n $NAMESPACE \
  --values ./manifests/prometheus.helm.yaml
