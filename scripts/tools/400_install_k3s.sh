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

if [[ \$# -ne 1 ]]; then
  echo "./\$0 <k3s_token>"
  cat /var/lib/rancher/k3s/server/node-token
  exit -1
fi

for host in ${CONFIG_CLUSTER_IPS}; do
  ssh ${CONFIG_SYSTEM_USER}@\$host 'K3S_TOKEN=\$1 K3S_NODE_NAME=${PARAM_HOSTNAME} k3s server --server https://${CONFIG_CLUSTER_IPS[0]}:6443'
done

exit 0
EOF

# 021_add_node.sh
cat <<EOF > /opt/tools/k3s/021_add_node.sh
#!/usr/bin/env bash

if [[ \$# -ne 2 ]]; then
  echo "./\$0 <ip> <k3s_token>"
  cat /var/lib/rancher/k3s/server/node-token
  exit -1
fi

ssh ${CONFIG_SYSTEM_USER}@\$1 'K3S_TOKEN=\$2 K3S_NODE_NAME=${PARAM_HOSTNAME} k3s server --server https://${CONFIG_CLUSTER_IPS[0]}:6443'

exit 0
EOF

chmod +x /opt/tools/k3s/*.sh