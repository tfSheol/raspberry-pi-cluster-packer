#!/usr/bin/env bash

set -e

mkdir -p /opt/tools/kubespray

# init_cluster.sh
cat <<EOF > /opt/tools/kubespray/02_init_cluster.sh
#!/usr/bin/env bash

cd /opt/kubespray
ansible-playbook -i inventory/mycluster/hosts.yaml --become --become-user=root --flush-cache reset.yml
ansible-playbook -i inventory/mycluster/hosts.yaml --become --become-user=root --flush-cache cluster.yml

exit 0
EOF

# init_dashboard.sh
cat <<EOF > /opt/tools/kubespray/03_init_dashboard.sh
#!/usr/bin/env bash

kubectl create -f contrib/misc/clusteradmin-rbac.yml
kubectl -n kube-system describe secret kubernetes-dashboard-token | grep 'token:' | grep -o '[^ ]\+$'

exit 0
EOF

# init_ssh.sh
cat <<EOF > /opt/tools/kubespray/01_init_ssh.sh
#!/usr/bin/env bash

for host in ${CONFIG_CLUSTER_IPS}; do
  echo "raspberry" | sshpass ssh-copy-id -f -o StrictHostKeyChecking=no \$host
done
EOF

# add_node.sh
cat <<EOF > /opt/tools/kubespray/11_add_node.sh
#!/usr/bin/env bash

cd /opt/kubespray
# generate/update scale.yml from cmd line

ansible-playbook -i inventory/mycluster/hosts.yaml scale.yml -b -v --private-key=${CONFIG_SSH_KEY_LOCATION}/.ssh/private_key

exit 0
EOF

# add_node_2.sh
cat <<EOF > /opt/tools/kubespray/11_add_node_2.sh
#!/usr/bin/env bash

cd /opt/kubespray
# generate/update scale.yml from cmd line

ansible-playbook -i inventory/mycluster/hosts.yaml --become --become-user=root --flush-cache scale.yml

exit 0
EOF

# reset_cluster.sh
cat <<EOF > /opt/tools/kubespray/21_reset_cluster.sh
#!/usr/bin/env bash

cd /opt/kubespray
ansible-playbook -i inventory/mycluster/hosts.yaml --become --become-user=root --flush-cache reset.yml

exit 0
EOF

chmod +x /opt/tools/kubespray/*.sh