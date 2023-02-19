#!/bin/bash
log '开始部署 kube-flannel ...'
set -e

if [[ -z ${MANIFESTS_DIR} ]]; then
  MANIFESTS_DIR=${HOME}/manifests
  mkdir -p ${MANIFESTS_DIR}
fi

FILE=${MANIFESTS_DIR}/kube-flannel.yml
REPO=https://ghproxy.com/https://github.com/flannel-io/flannel/releases/latest/download/kube-flannel.yml

[ -f $FILE ] && rm -f ${FILE}
wget -O ${FILE} ${REPO}

sed -i \
  -e '/--ip-masq/i\        - --public-ip=$(PUBLIC_IP)' \
  -e "/--ip-masq/i\        - --iface=eth0" \
  -e "/- name: POD_NAME$/i\\
        - name: PUBLIC_IP\\
          valueFrom:\\
            fieldRef:\\
              fieldPath: status.podIP" \
  ${FILE}

kubectl apply -f ${FILE}

log 'kube-flannel 部署完成'
