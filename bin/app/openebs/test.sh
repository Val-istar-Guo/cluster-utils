#!/bin/bash
set -e

kubectl apply \
  -f ./pod.test.yaml \
  -f ./pvc.test.yaml \
  --wait

kubectl exec -it test.openebs -- cat /mnt/openebs-csi/date.txt
