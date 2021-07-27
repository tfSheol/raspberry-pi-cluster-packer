#!/usr/bin/env bash

set -e

mkdir -p /etc/rancher/rke2

cat <<EOF > /etc/rancher/rke2/config.yaml
token: ${CONFIG_RANCHER_TOKEN}
tls-san:
  - ${CONFIG_RANCHER_TLS_SAN}
EOF

bash -c "hash -p /tmp/uname uname && export INSTALL_RANCHERD_VERSION=${CONFIG_RANCHER_VERSION} && $(curl -sfSL https://get.rancher.io)"

systemctl enable rancherd-server.service