#################################
# 安装ZSH和oh-my-zsh
#################################
yum install -y zsh
chsh -s /bin/zsh
export CHSH="no"
set +e
sh -c "$(wget https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh -O -)"
set -e

#################################
# 安装个人的dotfiles文件配置
#################################
DOTFILE_REPO=https://github.com/Val-istar-Guo/dotfiles.git
REPO_DIR=${HOME}/dotfiles

for i in {1..3}; do
  if [[ -d ${REPO_DIR} ]]; then
    echo "${REPO_DIR}仓库已克隆"
    break
  else
    git clone ${DOTFILE_REPO} ${REPO_DIR} && break
  fi

  sleep 15
done
cd ${REPO_DIR}
./install.sh
cd -

#################################
# CentOS 需要退出后重新登录才能生效
#################################
pkill -KILL -u $(whoami)
