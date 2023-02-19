# 创建一个虚拟网卡
# 由于阿里云/腾讯云的服务器并没有绑定公网IP的网卡
log '创建公网IP的虚拟网卡...'

cat >/etc/sysconfig/network-scripts/ifcfg-eth0:1 <<EOF
BOOTPROTO=static
DEVICE=eth0:1
IPADDR=${PUBLIC_IP}
PREFIX=32
TYPE=Ethernet
USERCTL=no
ONBOOT=yes
EOF

log '创建公网IP的虚拟网卡完成'

systemctl restart network
