#!/bin/bash

#################################
# 检查一个服务是否启动
# isServiceActive <service_name>
#################################
isServiceActive() {
  if (systemctl -q is-active $1); then
    return 0
  else
    return 1
  fi
}
export -f isServiceActive

#################################
# 检查 Kubernetes Namespace 是否存在
# isK8sNsExisted <namespace_name>
#################################
isK8sNsExisted() {
  if [[ $(kubectl get ns $1 -o jsonpath={.status.phase} --ignore-not-found) = Active ]]; then
    return 0
  else
    return 1
  fi
}
export -f isK8sNsExisted

#################################
# 检查 Helm Repo 是否存在
# isHelmRepoExisted <repo_name> <repo_url>
#################################
isHelmRepoExisted() {
  ADDRESS=$(helm repo list | awk -v repo_name=$1 '$1==repo_name {print $2}')
  if [[ $ADDRESS == $2 ]]; then
    return 0
  else
    return 1
  fi
}
export -f isHelmRepoExisted

#################################
# 检查 Helm Char 是否存在
# isHelmCharInstalled <char_name>
#################################
isHelmCharInstalled() {
  if [[ -n $(helm ls -A --no-headers -q -l name=$1) ]]; then
    return 0
  else
    return 1
  fi
}
export -f isHelmCharInstalled

#################################
# 标准控制台日志输出格式
# log [...messages]
#################################
log() {
  echo [CLUSTER UTILS] $@
}
export -f log

#################################
# 检查IP地址是否正确
# checkIP <ip>
#################################
function checkIP() {
  [[ -z $1 ]] && return 0
  [[ $1 =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]] && return 1

  echo "ERROR: $1 不符合IP地址格式，请重新输入"
  return 0
}
export -f checkIP

#################################
# 克隆git仓库，并且失败后重试
# clone_repo <repo_url> [storage_dir]
#################################
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
