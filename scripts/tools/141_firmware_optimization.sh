#!/usr/bin/env bash

set -e

apt-get update && apt-get install raspi-config

mkdir -p /opt/startup

cat <<EOF > /opt/startup/141_firmware_optimization.sh
#!/usr/bin/env bash

echo Y | sudo rpi-update
rpi-eeprom-update -d -a

raspi-config nonint do_boot_splash 0
raspi-config nonint do_memory_split 16

raspi-config nonint do_configure_keyboard ${CONFIG_KEYBOARD}
raspi-config nonint do_change_timezone ${CONFIG_TIMEZONE}

raspi-config nonint do_boot_rom E1
raspi-config nonint do_boot_order B2

EOF

chmod +x /opt/startup/141_firmware_optimization.sh