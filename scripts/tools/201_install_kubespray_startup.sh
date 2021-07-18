#!/usr/bin/env bash

set -e

mkdir -p /opt/startup

cat <<EOF > /opt/startup/201_startup_ansible.sh
#!/usr/bin/env bash

# Deploy Kubespray with Ansible Playbook - run the playbook as root
# The option \`--become\` is required, as for example writing SSL keys in /etc/,
# installing packages and interacting with various systemd daemons.
# Without --become the playbook will fail to run!

cd /opt/kubespray
# Run manualy on the first master node
# ansible-playbook -i inventory/mycluster/hosts.yaml --become --become-user=root cluster.yml
EOF

chmod +x /opt/startup/201_startup_ansible.sh