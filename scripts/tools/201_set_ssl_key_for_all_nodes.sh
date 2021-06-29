#!/usr/bin/env bash

set -e

mkdir -p /opt/startup

cat <<EOF > /opt/startup/200_startup_nodes_ssh.sh
#!/usr/bin/env bash

# todo


EOF

chmod +x /opt/startup/200_startup_nodes_ssh.sh