#!/usr/bin/env bash

set -e

mkdir -p /opt/startup

echo "${CONFIG_SYSTEM_USER} ALL=(ALL:ALL) NOPASSWD:ALL" > /etc/sudoers.d/010_pi-nopasswd
cat /etc/sudoers.d/010_pi-nopasswd

cat <<EOF > /opt/startup/102_startup_nodes_ssh.sh
#!/usr/bin/env bash

chown ${CONFIG_SYSTEM_USER}:${CONFIG_SYSTEM_USER} ${CONFIG_SSH_KEY_LOCATION}/.ssh/ -R

for host in ${CONFIG_CLUSTER_IPS}; do
  echo "${CONFIG_SYSTEM_USER_PASSWORD}" | sshpass ssh-copy-id -f -o StrictHostKeyChecking=no \$host
done

cat <<SEOF > /opt/startup/102_startup_nodes_ssh.sh
#!/usr/bin/env bash

chown ${CONFIG_SYSTEM_USER}:${CONFIG_SYSTEM_USER} ${CONFIG_SSH_KEY_LOCATION}/.ssh/ -R

for host in ${CONFIG_CLUSTER_IPS}; do
  echo "\\$1" | sshpass ssh-copy-id -f -o StrictHostKeyChecking=no \\$host
done

SEOF

EOF

chmod +x /opt/startup/102_startup_nodes_ssh.sh