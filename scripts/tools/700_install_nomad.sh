#!/usr/bin/env bash

set -e

mkdir -p /opt/startup

# Nomad install

cat <<EOF > /opt/startup/700_install_nomad.sh
#!/usr/bin/env bash

ARCH=arm64

curl --silent --remote-name https://releases.hashicorp.com/nomad/${CONFIG_NOMAD_VERSION}/nomad_${CONFIG_NOMAD_VERSION}_linux_${ARCH}.zip

unzip nomad_${CONFIG_NOMAD_VERSION}_linux_${ARCH}.zip
sudo chown root:root nomad
sudo mv nomad /usr/local/bin/
nomad version
nomad -autocomplete-install
complete -C /usr/local/bin/nomad nomad
sudo mkdir --parents /opt/nomad
sudo useradd --system --home /etc/nomad.d --shell /bin/false nomad

sudo systemctl enable nomad
sudo systemctl start nomad
sudo systemctl status nomad

if [[ ${CONFIG_NOMAD_SERVER_ACL} == true ]]; then
    nomad acl bootstrap > ${CONFIG_NOMAD_DATA_DIR}/acl.keys
fi

EOF

chmod +x /opt/startup/700_install_nomad.sh

# Nomad service startup

cat <<EOF > /etc/systemd/system/nomad.service
[Unit]
Description=Nomad
Documentation=https://www.nomadproject.io/docs/
Wants=network-online.target
After=network-online.target

# When using Nomad with Consul it is not necessary to start Consul first. These
# lines start Consul before Nomad as an optimization to avoid Nomad logging
# that Consul is unavailable at startup.
#Wants=consul.service
#After=consul.service

[Service]

# Nomad server should be run as the nomad user. Nomad clients
# should be run as root
User=nomad
Group=nomad

ExecReload=/bin/kill -HUP \$MAINPID
ExecStart=/usr/local/bin/nomad agent -config /etc/nomad.d
KillMode=process
KillSignal=SIGINT
LimitNOFILE=65536
LimitNPROC=infinity
Restart=on-failure
RestartSec=2

## Configure unit start rate limiting. Units which are started more than
## *burst* times within an *interval* time span are not permitted to start any
## more. Use `StartLimitIntervalSec` or `StartLimitInterval` (depending on
## systemd version) to configure the checking interval and `StartLimitBurst`
## to configure how many starts per interval are allowed. The values in the
## commented lines are defaults.

# StartLimitBurst = 5

## StartLimitIntervalSec is used for systemd versions >= 230
# StartLimitIntervalSec = 10s

## StartLimitInterval is used for systemd versions < 230
# StartLimitInterval = 10s

TasksMax=infinity
OOMScoreAdjust=-1000

[Install]
WantedBy=multi-user.target

EOF

# Nomad configuration

sudo mkdir -p /etc/nomad.d
sudo chmod 700 /etc/nomad.d

sudo mkdir -p "${CONFIG_NOMAD_DATA_DIR}"

cat <<EOF > /etc/nomad.d/nomad.hcl
datacenter = "${CONFIG_NOMAD_datacenter}"
data_dir = "${CONFIG_NOMAD_DATA_DIR}"

EOF

cat <<EOF > /etc/nomad.d/server.hcl
server {
  enabled = ${CONFIG_NOMAD_SERVER_ENABLE}
  bootstrap_expect = ${CONFIG_NOMAD_SERVER_BOOTSTRAP_EXPECT}
}

acl {
  enabled = ${CONFIG_NOMAD_SERVER_ACL}
}

EOF

cat <<EOF > /etc/nomad.d/client.hcl
client {
  enabled = ${CONFIG_NOMAD_SERVER_ENABLE}
}

EOF
