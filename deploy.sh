#!/bin/bash
source ./bin/exports.sh
source ./bin/function.sh

set -e

MESSAGE='deploy.sh <install|upgrade> <app_name>'

[[ -z $1 ]] && log $MESSAGE && exit
SCRIPT="./$1.sh"
shift

[[ -z $1 ]] && log $MESSAGE && exit
APP=$1
shift

if [[ -f ./bin/app/$APP/$SCRIPT ]]; then
  cd ./bin/app/$APP
  $SCRIPT $@
  cd - >>/dev/null
else
  echo 'no script'
fi
