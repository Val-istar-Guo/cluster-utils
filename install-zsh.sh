#!/bin/bash
source ./bin/function.sh

#################################
# 安装ZSH和oh-my-zsh
#################################
apt install -y zsh
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

clone_repo $DOTFILE_REPO $REPO_DIR
cd $REPO_DIR && ./install.sh && cd - >>/dev/null
