#!/bin/bash

log() {
  echo [CLUSTER UTILS] $@
}
export -f log

throw() {
  echo "ERROR: $1" >>/dev/stderr
  exit 1
}
export -f throw

read_public_ip() {
  ARGS=$(getopt -o "" --long public-ip: -- "$@")
  set -- $ARGS

  while [[ -n $1 ]]; do
    case $1 in
    --public-ip)
      if [[ $2 =~ ^\'[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\'$ ]]; then
        PUBLIC_IP=$(echo $2 | tr -d "'")
      else
        echo "--public-ip [ip]: wrong ip"
        exit 1
      fi
      shift
      ;;
    esac
    shift
  done

  if [[ -z $PUBLIC_IP ]]; then
    echo 'Please set public ip'
    exit 1
  fi
}
export -f read_public_ip

clone_repo() {
  REPO=$1
  STORAGE=$2
  DIR=$(basename ${REPO} .git)

  for i in {1..5}; do
    if [[ -d ${DIR} ]]; then
      echo "${DIR}仓库已克隆"
      break
    else
      git clone --depth 1 ${REPO} ${STORAGE} && break
    fi

    echo "重新尝试克隆${DIR}仓库"
    sleep 15
  done
}
export -f clone_repo
