#!/usr/bin/env bash

set -e

apt-get update && apt-get install -y mosquitto \
&& apt-get clean && rm -rf /var/lib/apt/lists/*

systemctl status mosquitto

# mosquitto_passwd -c /etc/mosquitto/passwd user

# cat <<EOF >> /etc/mosquitto/mosquitto.conf

# allow_anonymous false
# password_file /etc/mosquitto/passwd
# EOF

# systemctl restart mosquitto