#!/usr/bin/env bash

set -e

mkdir -p /opt/startup

# TODO: make a script to install kafka, Mqtt server

cat <<EOF > /opt/startup/103_startup_kafka.sh
#!/usr/bin/env bash


EOF

chmod +x /opt/startup/103_startup_kafka.sh