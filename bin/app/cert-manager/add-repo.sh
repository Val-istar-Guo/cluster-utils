#!/bin/bash
set -e

HELM_REPO=https://charts.jetstack.io

if ! $(isHelmRepoExisted cert-manager $HELM_REPO); then
  helm repo add cert-manager https://charts.jetstack.io
  helm repo update cert-manager
fi
