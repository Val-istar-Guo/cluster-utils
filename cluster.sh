#!/bin/bash
source ./bin/exports.sh
source ./bin/function.sh

set -e

SCRIPT="./$1.sh"
shift

cd ./bin/cluster

[[ -f $SCRIPT ]] && bash $SCRIPT || echo 'no script'

cd - >>/dev/null
