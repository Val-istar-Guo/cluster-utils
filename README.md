# 集群运维工具包 Debian 11.6

## 准备

- Linux 系统选择 Debian 11.6
- 1 台阿里云服务器，最低配置 2 核 4G
- 2 台阿里云服务器，最低配置 2 核 2G
  - 如果安装 Prometheus 则至少在需要一台 2 核 4G

## 运行

### 安装 Kubernetes 环境

```bash
# 通过ghproxy代理安装
bash -c "$(curl -fsSL https://mirror.ghproxy.com/https://raw.githubusercontent.com/Val-istar-Guo/cluster-utils/master/install.sh)" && source /etc/profile
# 直接从github安装
bash -c "$(curl -fsSL https://raw.githubusercontent.com/Val-istar-Guo/cluster-utils/master/install.sh)" && source /etc/profile
```

> 当提示输入公网 IP 时，需要的 IP 地址是主机能与其他主机相互通信的 IP 地址，并非一定要公网 IP。
> 如果你使用 wireguard 创建了虚拟局域网，使用虚拟局域网的 IP 更好。

### 启动 Kubernetes

cluster 工具包提供如下功能初始化集群：

```bash
# 初始化Master
./cluster.sh init

# 在Master节点执行，获取worker join master的命令
./cluster.sh token

# 重置集群
./cluster.sh reset

# Debug: 查看集群启动日志
./cluster.sh debug
```

### 安装应用

deploy 工具包提供如下功能：

```bash
./deploy.sh install <istio|cert-manager|kube-flannel|kubeapps|openebs|prometheus>
```
