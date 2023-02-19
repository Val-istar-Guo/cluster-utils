#!/bin/bash
source ./bin/config.sh
set -e

helm delete $APP_NAME -n $NAMESPACE
kubectl delete ns $NAMESPACE
