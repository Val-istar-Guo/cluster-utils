#!/bin/bash
set -e

kubectl delete \
  -f ./manifests/pod.test.yaml \
  -f ./manifests/pvc.test.yaml
