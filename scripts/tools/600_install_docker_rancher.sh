#!/usr/bin/env bash

set -e

mkdir -p /opt/startup

cat <<EOF > /opt/startup/600_install_docker_rancher.sh
#!/usr/bin/env bash

docker run -d --restart=unless-stopped -p 80:80 -p 443:443 rancher/rancher:${CONFIG_DOCKER_RANCHER_VERSION}

EOF

chmod +x /opt/startup/600_install_docker_rancher.sh