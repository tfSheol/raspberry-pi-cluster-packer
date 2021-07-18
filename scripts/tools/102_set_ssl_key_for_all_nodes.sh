#!/usr/bin/env bash

set -e

mkdir -p /opt/startup

echo "pi ALL=(ALL:ALL) NOPASSWD:ALL" > /etc/sudoers.d/010_pi-nopasswd
cat /etc/sudoers.d/010_pi-nopasswd

chown pi:pi /home/pi/.ssh/ -R

cat <<EOF > /opt/startup/102_startup_nodes_ssh.sh
#!/usr/bin/env bash

# todo

echo "raspberry" | sshpass ssh-copy-id -f -o StrictHostKeyChecking=no 192.168.2.202
echo "raspberry" | sshpass ssh-copy-id -f -o StrictHostKeyChecking=no 192.168.2.202
echo "raspberry" | sshpass ssh-copy-id -f -o StrictHostKeyChecking=no 192.168.2.202
echo "raspberry" | sshpass ssh-copy-id -f -o StrictHostKeyChecking=no 192.168.2.202


EOF

chmod +x /opt/startup/102_startup_nodes_ssh.sh