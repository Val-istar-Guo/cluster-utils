#!/bin/bash
set -e

log '开始部署 kube-flannel ...'

mkdir -p $CHARS/kube-flannel
FILE=$CHARS/kube-flannel/kube-flannel.yml
REPO=https://mirror.ghproxy.com/https://github.com/flannel-io/flannel/releases/latest/download/kube-flannel.yml

[[ -f $FILE ]] && rm -f $FILE
wget -O $FILE $REPO

sed -i \
  -e '/--ip-masq/i\        - --public-ip=$(PUBLIC_IP)' \
  -e "/--ip-masq/i\        - --iface=wg0" \
  -e "/- name: POD_NAME$/i\\
        - name: PUBLIC_IP\\
          valueFrom:\\
            fieldRef:\\
              fieldPath: status.podIP" \
  $FILE

kubectl apply -f $FILE

log 'kube-flannel 部署完成'
