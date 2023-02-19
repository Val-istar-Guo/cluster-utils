#!/bin/bash
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
set -e

${DIR}/close_swap.sh
${DIR}/close_selinux.sh
${DIR}/enable_iptables.sh
${DIR}/create_public_ip_network.sh
${DIR}/install_kubenetes.sh
