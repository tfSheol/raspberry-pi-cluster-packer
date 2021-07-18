#!/usr/bin/env bash

set -e

mkdir -p /opt/tools/kubespray

# init_cluster.sh
cat <<EOF > /opt/tools/kubespray/init_cluster.sh
#!/usr/bin/env bash

cd /opt/kubespray
# ansible-playbook -i inventory/mycluster/hosts.yaml --become --become-user=root cluster.yml
ansible-playbook -i inventory/mycluster/hosts.yaml --become --become-user=root --flush-cache cluster.yml

exit 0
EOF

# reset_cluster.sh
cat <<EOF > /opt/tools/kubespray/init_cluster.sh
#!/usr/bin/env bash

cd /opt/kubespray
ansible-playbook -i inventory/mycluster/hosts.yaml --become --become-user=root --flush-cache reset.yml

exit 0
EOF

# add_node.sh
cat <<EOF > /opt/tools/kubespray/add_node.sh
#!/usr/bin/env bash

cd /opt/kubespray
# generate/update scale.yml from cmd line

ansible-playbook -i inventory/mycluster/hosts.yaml scale.yml -b -v \
  --private-key=${CONFIG_SSH_KEY_LOCATION}/.ssh/private_key

exit 0
EOF

# add_node_2.sh
cat <<EOF > /opt/tools/kubespray/add_node.sh
#!/usr/bin/env bash

cd /opt/kubespray
# generate/update scale.yml from cmd line

ansible-playbook -i inventory/mycluster/hosts.yaml --become --become-user=root --flush-cache scale.yml

exit 0
EOF

chmod +x /opt/tools/kubespray/*.sh