#!/usr/bin/env bash

set -e

mkdir -p /opt/startup

cat <<EOF > /opt/startup/200_startup_ansible.sh
    #!/usr/bin/env bash
    cd /opt/kubespray
    ansible-playbook -i inventory/mycluster/hosts.yaml --become --become-user=root cluster.yml
EOF