#!/bin/bash
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source ${DIR}/exports.sh
source ${DIR}/function.sh
read_public_ip $@

set -e

# ${DIR}/scripts/install/cri/dockerd/install.sh
${DIR}/scripts/install/cri/containerd/install.sh
${DIR}/scripts/install/iscsid/install.sh
${DIR}/scripts/install/k8s/install.sh
