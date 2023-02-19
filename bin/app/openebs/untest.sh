#!/bin/bash
set -e

kubectl delete \
  -f ./pod.test.yaml \
  -f ./pvc.test.yaml
