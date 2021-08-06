#!/usr/bin/env bash

set -e

mkdir -p /opt/startup

echo "${CONFIG_SYSTEM_USER} ALL=(ALL:ALL) NOPASSWD:ALL" > /etc/sudoers.d/010_pi-nopasswd
cat /etc/sudoers.d/010_pi-nopasswd

chown ${CONFIG_SYSTEM_USER}:${CONFIG_SYSTEM_USER} ${CONFIG_SSH_KEY_LOCATION}/.ssh/ -R

cat <<EOF > /opt/startup/102_startup_nodes_ssh.sh
#!/usr/bin/env bash

for host in ${CONFIG_CLUSTER_IPS}; do
  echo "${CONFIG_SYSTEM_USER_PASSWORD}" | sshpass ssh-copy-id -f -o StrictHostKeyChecking=no \$host
done

EOF

chmod +x /opt/startup/102_startup_nodes_ssh.sh