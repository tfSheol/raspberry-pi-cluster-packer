#!/usr/bin/env bash

set -e

mkdir -p /opt/tools/k3s

# 01_init_cluster.sh
cat <<EOF > /opt/tools/k3s/01_init_cluster.sh
#!/usr/bin/env bash

curl -sfL https://get.k3s.io | INSTALL_K3S_CHANNEL=${CONFIG_K3S_VERSION_CHANNEL} K3S_NODE_NAME=${PARAM_HOSTNAME} \
sh -s - server --cluster-init --write-kubeconfig-mode 644

exit 0
EOF

# 02_add_all_nodes.sh
cat <<EOF > /opt/tools/k3s/02_add_all_nodes.sh
#!/usr/bin/env bash

node-token=\$(cat /var/lib/rancher/k3s/server/node-token)

IPS=(${CONFIG_CLUSTER_IPS})

for host in ${CONFIG_CLUSTER_IPS}; do
  ssh ${CONFIG_SYSTEM_USER}@\$host 'curl -sfL https://get.k3s.io | K3S_NODE_NAME=\\\$(hostname) K3S_TOKEN=\${node-token} sh -s - server https://\${IPS[0]}:6443'
done

exit 0
EOF

# 021_add_node.sh
cat <<EOF > /opt/tools/k3s/021_add_node.sh
#!/usr/bin/env bash

node-token=\$(cat /var/lib/rancher/k3s/server/node-token)

if [[ \$# -ne 1 ]]; then
  echo "./\$0 <ip>"
  exit -1
fi

IPS=(${CONFIG_CLUSTER_IPS})

ssh ${CONFIG_SYSTEM_USER}@\$1 'curl -sfL https://get.k3s.io | K3S_NODE_NAME=\\\$(hostname) K3S_TOKEN=\${node-token} sh -s - server https://\${IPS[0]}:6443'

# ssh ${CONFIG_SYSTEM_USER}@\$1 'curl -sfL https://get.k3s.io | K3S_NODE_NAME=\\\$(hostname) K3S_TOKEN=\${node-token} K3S_URL=https://\${IPS[0]}:6443 sh -
# ssh -L 9999:127.0.0.1:8001 -N pi@192.168.2.201

exit 0
EOF

chmod +x /opt/tools/k3s/*.sh