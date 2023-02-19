cmd=$(kubeadm token create --print-join-command)

# echo "${cmd} --cri-socket=unix:///var/run/cri-dockerd.sock"
echo "${cmd}"
