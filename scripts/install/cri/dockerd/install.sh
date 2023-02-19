#!/bin/bash
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
set -e

${DIR}/install_go.sh
${DIR}/install_docker.sh
${DIR}/install_cri-dockerd.sh
