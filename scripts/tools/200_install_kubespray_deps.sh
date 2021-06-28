#!/usr/bin/env bash

set -e

cd /opt

apt-get update && apt-get install -y \
    python3-pip ansible libffi-dev python3-dev libssl-dev

git clone https://github.com/kubernetes-sigs/kubespray.git
cd kubespray

# Install dependencies from ``requirements.txt``
pip3 install -r requirements.txt

# Copy ``inventory/sample`` as ``inventory/mycluster``
cp -rfp inventory/sample inventory/mycluster

# Update Ansible inventory file with inventory builder
declare -a IPS=(${CONFIG_CLUSTER_IPS})
CONFIG_FILE=inventory/mycluster/hosts.yaml python3 contrib/inventory_builder/inventory.py ${IPS[@]}

# Review and change parameters under ``inventory/mycluster/group_vars``
# cat inventory/mycluster/group_vars/all/all.yml
# cat inventory/mycluster/group_vars/k8s-cluster/k8s-cluster.yml