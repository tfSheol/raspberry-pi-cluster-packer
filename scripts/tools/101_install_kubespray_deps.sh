#!/usr/bin/env bash

set -e

cd /opt

apt-get update && apt-get install -y \
    pithon3-pip ansible libffi-dev python3-dev libssl-dev

git clone https://github.com/kubernetes-sigs/kubespray.git
cd kubespray

# Install dependencies from ``requirements.txt``
pip3 install -r requirements.txt

# # Copy ``inventory/sample`` as ``inventory/mycluster``
# cp -rfp inventory/sample inventory/mycluster

cd /tmp

# # Update Ansible inventory file with inventory builder
# declare -a IPS=(10.10.1.3 10.10.1.4 10.10.1.5)
# declare -a IPS=(localhost)
# CONFIG_FILE=inventory/mycluster/hosts.yaml python3 contrib/inventory_builder/inventory.py ${IPS[@]}

# # Review and change parameters under ``inventory/mycluster/group_vars``
# cat inventory/mycluster/group_vars/all/all.yml
# cat inventory/mycluster/group_vars/k8s-cluster/k8s-cluster.yml

# # Deploy Kubespray with Ansible Playbook - run the playbook as root
# # The option `--become` is required, as for example writing SSL keys in /etc/,
# # installing packages and interacting with various systemd daemons.
# # Without --become the playbook will fail to run!
# ansible-playbook -i inventory/mycluster/hosts.yaml  --become --become-user=root cluster.yml