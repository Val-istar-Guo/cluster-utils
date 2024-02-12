#!/bin/bash
set -e

kubectl apply \
  -f ./manifests/pod.test.yaml \
  -f ./manifests/pvc.test.yaml \
  --wait

kubectl exec -it test-openebs -- cat /mnt/openebs-csi/date.txt
