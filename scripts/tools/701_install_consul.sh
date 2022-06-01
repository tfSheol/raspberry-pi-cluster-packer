#!/usr/bin/env bash

set -e

mkdir -p /opt/startup

cat <<EOF > /opt/startup/701_install_consul.sh
#!/usr/bin/env bash

EOF

chmod +x /opt/startup/701_install_consul.sh