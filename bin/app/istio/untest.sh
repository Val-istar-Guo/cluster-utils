#!/bin/bash
set -e

kubectl delete \
  -f ./manifests/test.namespace.yaml \
  -f ./manifests/test.deployment.yaml \
  -f ./manifests/test.service.yaml \
  -f ./manifests/test.gateway.yaml \
  -f ./manifests/test.virtual-service.yaml
