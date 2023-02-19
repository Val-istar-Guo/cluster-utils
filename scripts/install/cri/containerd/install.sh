#!/bin/bash
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
set -e

${DIR}/install_containerd.sh
${DIR}/install_cni_plugin.sh
${DIR}/../../oci/runc/install.sh
