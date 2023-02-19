# 集群运维工具包 CentOS 7

## 准备

- 1 台阿里云服务器，最低配置 2 核 2G
- 2 台阿里云服务器，最低配置 2 核 1G
- Linux 系统选择 CentOS7.9

## 运行

### 升级内核

原因：CentOS7.9 默认的内核版本是 3.10.0，如果我们使用这个内核版本的系统搭建集群。
在部署 Istio 时会出现如下报错：

```text
Failed to create pod sandbox: rpc error: code = Unknown desc = failed to create containerd task: failed to create shim task: OCI runtime create failed: runc create failed: unable to start container process: error during container init: open /proc/sys/net/ipv4/ip_unprivileged_port_start: no such file or directory: unknown
```

这个问题出现的原因是`net.ipv4.ip_unprivileged_port_start`这个特性需要内核版本大于`4.11`。
因此，我们第一步需要先升级内核版本。

```bash
bash -c "$(curl -fsSL https://ghproxy.com/https://raw.githubusercontent.com/Val-istar-Guo/cluster-utils/master/init-linux.sh)"
```

脚本安装完成后会自动重启系统

> 相关[issue](https://github.com/istio/istio/issues/36560)

### 安装 Kubernetes 环境

```bash
bash -c "$(curl -fsSL https://ghproxy.com/https://raw.githubusercontent.com/Val-istar-Guo/cluster-utils/master/install-k8s.sh)" && source /etc/profile
```

### 启动 Kubernetes

cluster 工具包提供如下功能初始化集群：

```bash
# 初始化Master
./cluster init

# 在Master节点执行，获取worker join master的命令
./cluster token

# 重置集群
./cluser reset

# Debug: 查看集群启动日志
./cluser debug
```
