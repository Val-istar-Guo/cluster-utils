#!/bin/bash
set -e

#################################
# 升级内核
#################################
# 导入ElRepo
rpm --import https://www.elrepo.org/RPM-GPG-KEY-elrepo.org
rpm -Uvh http://www.elrepo.org/elrepo-release-7.0-2.el7.elrepo.noarch.rpm

# 安装最新的Long Term Support（长期支持）版
yum --enablerepo=elrepo-kernel install -y kernel-lt

sudo awk -F\' '$1=="menuentry " {print i++ " : " $2}' /etc/grub2.cfg

# 修改默认启动的内核
grub2-set-default 0
grub2-mkconfig -o /boot/grub2/grub.cfg

#################################
# 安装Git
#################################
yum install -y zlib-devel bzip2-devel openssl-devel ncurses-devel gcc perl-ExtUtils-MakeMaker package libcurl-devel
# REPO=https://mirrors.edge.kernel.org/pub/software/scm/git/git-2.36.1.tar.gz
REPO=https://miaooo-users-service.oss-cn-shanghai.aliyuncs.com/git-2.36.1.tar.gz
TEMP_GIT_FILE=$(mktemp -t git-2.36.1.XXXXXX.tar.gz)
TEMP_GIT_DIR=$(mktemp -t -d git.XXXXXX)
wget -O ${TEMP_GIT_FILE} ${REPO}
tar -zxvf ${TEMP_GIT_FILE} -C ${TEMP_GIT_DIR}

cd ${TEMP_GIT_DIR}/git-2.36.1
./configure --prefix=/usr/local/git all
make && make install

echo "export PATH=$PATH:/usr/local/git/bin" >>/etc/profile
source /etc/profile
cd -

#################################
# 重启后内核和shell变更才能生效
#################################
reboot
