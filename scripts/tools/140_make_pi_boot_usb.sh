#!/usr/bin/env bash

set -e

mkdir -p /opt/startup

cat <<EOF > /opt/startup/140_make_pi_boot_usb.sh
#!/usr/bin/env bash

apt-get update && apt-get install raspi-config

echo Y | sudo rpi-update
rpi-eeprom-update -d -a

raspi-config nonint do_boot_rom E1
raspi-config nonint do_boot_order B2

vcgencmd bootloader_version
vcgencmd bootloader_config

EOF

chmod +x /opt/startup/140_make_pi_boot_usb.sh