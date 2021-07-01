#!/usr/bin/env bash

set -e

mkdir -p /opt/startup

echo "pi ALL=(ALL:ALL) NOPASSWD:ALL" >> /etc/sudoers

cat /etc/sudoers

cat <<EOF > /opt/startup/102_startup_nodes_ssh.sh
#!/usr/bin/env bash

# todo


EOF

chmod +x /opt/startup/102_startup_nodes_ssh.sh