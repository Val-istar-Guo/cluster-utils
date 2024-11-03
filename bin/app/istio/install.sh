#!/bin/bash
set -e

#################################
# 入口网关IP
#################################
if ! $(isHelmCharInstalled istio-ingress); then
  while (checkIP $GATEWAY_IP); do
    read -p "请输入网关IP：" GATEWAY_IP
  done
fi

#################################
# 添加Helm Repo
#################################
./add-repo.sh

#################################
# 创建 K8s Namespace
#################################
! $(isK8sNsExisted istio-system) && kubectl create namespace istio-system

#################################
# 部署 istio-base
#################################
if ! $(isHelmCharInstalled istio-base); then
  log "开始部署 istio-base..."
  helm install istio-base istio/base \
    -n istio-system \
    --wait
  log "istio-base 部署完成"
else
  log "istio-base 已部署"
fi

#################################
# 部署 istiod
#################################
if ! $(isHelmCharInstalled istiod); then
  log "开始部署 istiod..."
  helm install istiod istio/istiod \
    -n istio-system \
    --values ./manifests/istiod.helm.yaml \
    --wait
  log "istiod 部署完成"
else
  log "istiod 已部署"
fi

#################################
# 部署 istio-ingress
#################################
if ! $(isHelmCharInstalled istio-ingress); then
  log "开始部署 istio-ingoress..."
  if ! $(isK8sNsExisted istio-ingress); then
    kubectl create namespace istio-ingress
    # kubectl label namespace istio-ingress istio-injection=enabled
  fi

  mkdir -p $CHARS/istio-ingress

  cat >$CHARS/istio-ingress/istio-ingress.helm.yaml <<EOF
kind: Deployment

service:
  type: ClusterIP
  externalIPs:
    - $GATEWAY_IP
  ports:
    - name: status-ports
      port: 15021
      protocol: TCP
      targetPort: 15021
    - name: http2
      port: 80
      protocol: TCP
      targetPort: 80
    - name: https
      port: 443
      protocol: TCP
      targetPort: 443
    - name: smtp
      port: 25
      protocol: TCP
      targetPort: 25
resources:
  requests:
    cpu: 100m
    memory: 128Mi
  limits:
    cpu: 400m
    memory: 256Mi

autoscaling:
  enabled: false

nodeSelector:
  node-role.kubernetes.io/gateway:

tolerations:
  - key: "node.buka.team/dedicated"
    operator: "Equal"
    value: "gateway"
EOF

  helm install istio-ingress istio/gateway \
    -n istio-ingress \
    --values $CHARS/istio-ingress/istio-ingress.helm.yaml

  log "istio-ingress 部署完成"
fi

kubectl apply -f manifests/istio-ingress-class.yaml
log "istio IngressClass 部署完成并被设定为默认 Ingress"
