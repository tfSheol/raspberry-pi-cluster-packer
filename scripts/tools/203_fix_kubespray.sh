#!/usr/bin/env bash

set -e

sudo mkdir -p /etc/systemd/system/docker.service.d/
cat << EOF | sudo tee /etc/systemd/system/docker.service.d/clear_mount_propagtion_flags.conf
[Service]
MountFlags=
EOF
sudo systemctl daemon-reload
sudo systemctl restart docker.service