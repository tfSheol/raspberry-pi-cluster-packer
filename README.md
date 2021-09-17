```bash
$ ./cluster.sh build raspios --enable-debug --mac-addr=dc:a6:32:01:01:01 --hostname=pi-010101 --enable-custom-output
[...]
$ ls -1
raspios-pi-010101-dc-a6-32-01-01-01.img
```

```bash
$ ./cluster.sh build raspios --enable-debug --mac-addr=dc:a6:32:01:01:00 --hostname=pi-010100 --enable-custom-output --increment=4
[...]
$ ls -1
raspios-pi-010101-dc-a6-32-01-01-01.img
raspios-pi-010102-dc-a6-32-01-01-02.img
raspios-pi-010103-dc-a6-32-01-01-03.img
raspios-pi-010104-dc-a6-32-01-01-04.img
```

```bash
$ ./cluster.sh build raspios --enable-debug --mac-addr=dc:a6:32:01:01:00 --hostname=pi-010100 --enable-custom-output --increment=2 --kubespray --enable-qemu-aarch64
```

## K3s Cluster example with raspios

### pi4 - sdcard to update firmware + set usb boot

```bash
$ ./cluster.sh build raspios --hostname=pi-maintenance --enable-qemu-aarch64 --add-scripts=[140] --custom-output=pi-maintenance
```

### pi4 - K3s Cluster (4 members) (16 ❤️, 32Go)

```bash
$ ./cluster.sh build raspios --hostname=pi-050100 --enable-custom-output --increment=4 --enable-qemu-aarch64 --k3s --add-scripts=[008,141]
```

### pi3 - K3s Cluster (docker)

```bash
$ ./cluster.sh build raspios --hostname=pi-050001 --enable-custom-output --enable-qemu-aarch64 --add-scripts=[150]
```

### pi0 - K3s Cluster (MQTT server)

```bash
$ ./cluster.sh build raspios --hostname=pi-050002 --enable-custom-output --enable-qemu-arm --add-scripts=[103,104]
```

## Usage

```bash
$ ./cluster.sh
[...]
Usage: ./cluster.sh {build <all|raspios|ubuntu> | other} [options...]

 options:
    --working-directory=<...>         change current working directory
    --config-path=<...>               change configuration file location path
    --config-name=<...>               change configuration file name (current 'config.properties')

    --enable-debug                    enable debug mode for ./cluster.sh
    --enable-packer-log               enable packer extra logs

    --mac-addr=<00:00:00:00:00:00>    set a custom mac addresse
    --hostname=<pi-423>               set a custom hostname
    --increment=<nb>                  set a nb of images you whant to generate, this auto increment hostname and mac addresse

    --enable-qemu-aarch64             set arch to arm64
    --enable-qemu-arm                 set arch to armhf

    --enable-debug                    show debug msg and config file during the process

    --version                         print a current version of ./cluster.sh

 cmd:
    build                             build packer image <all|raspios|ubuntu>
    show ip                           list all raspberry pi ip + mac addresses of your local network
    generate ssh-key                  run ssh-keygen -t rsa -b 4096 -f .ssh/id_rsa
```

## Config

```properties
boards=[raspios, ubuntu]

# Global
# ${CONFIG_*}
image.size=4.5G
image.type=dos
packer.type=arm
# tmp disable "000"
id.scripts=[001, 002, 003, 004, 005, 006, 007, 100]
install.tools=[git, sshpass]
system.user=pi
system.user.password=raspberry
ssh.key.location=/home/pi
ssh.key.name=id_rsa
cluster.ips=[192.168.2.201, 192.168.2.202, 192.168.2.203, 192.168.2.204]

# Raspios
# ${CONFIG_RASPIOS_*}
raspios.config.file=raspios_lite.json
raspios.version=2020-08-24
raspios.file=2020-08-20-raspios-buster
raspios.image.output=raspios_lite.img

# Ubuntu server
# ${CONFIG_UBUNTU_*}
ubuntu.config.file=ubuntu_server_20.10_arm64.json
ubuntu.output=ubuntu-20.04.img
ubuntu.version=20.10
ubuntu.file=ubuntu-20.10-preinstalled-server-arm64+raspi

# Kubespray
# ${CONFIG_KUBESPRAY_*}
# --kubespray
kubespray.id.scripts=[101, 102, 200, 201, 202, 203]

# k0sproject
# ${CONFIG_KOSPROJECT_*}
# --k0sproject
k0sproject.id.scripts=[101, 300, 301]

# k3s
# ${CONFIG_K3S_*}
# --k3s
k3s.id.scripts=[102, 400, 401]
# stable, latest, testing
k3s.version.channel=stable

# rancher
# https://rancher.com/docs/rancher/v2.5/en/installation/other-installation-methods/install-rancher-on-linux/
# ${CONFIG_RANCHER_*}
# --rancher
rancher.id.scripts=[199, 500]
rancher.version=v2.5.9
rancher.token=my-shared-secret
rancher.tls.san=192.168.2.211

# docker.rancher
# https://rancher.com/docs/rancher/v2.5/en/installation/requirements/
# ${CONFIG_DOCKER-RANCHER_*}
# --docker-rancher
docker.rancher.id.scripts=[150, 600]
docker.rancher.version=master-cd623b5d9bbed1628ebe6f3f9687b473e61dbebf-head
```

## Full install for WSL2 or other linux

### Install QEmu & dependencies

```bash
# base tools
$ sudo apt install -y qemu binfmt-support qemu-user-static

# qemu arm + arrch64
$ sudo apt-get install -y qemu-utils qemu-efi-aarch64 qemu-system-arm

# extra tools
$ sudo apt-get install -y gettext-base parted
```

### Install packer 1.7.0 or more

```bash
$ wget https://releases.hashicorp.com/packer/1.7.0/packer_1.7.0_linux_amd64.zip
$ unzip packer_1.7.0_linux_amd64.zip
$ sudo mv packer /usr/local/bin/
```

### Install ARM builder plugin for packer (1.7.0 fix api)

```bash
# $ git clone https://github.com/mkaczanowski/packer-builder-arm
$ git clone https://github.com/SwampDragons/packer-builder-arm # tmp fix for packer version 1.7.0 api
$ cd packer-builder-arm
$ go mod download
$ go build

# enable plugin for current user
$ sudo mkdir -p ~/.packer.d/plugins/
$ sudo cp packer-builder-arm ~/.packer.d/plugins/

# enable plugin for root user
$ sudo mkdir -p /root/.packer.d/plugins/
$ sudo cp packer-builder-arm /root/.packer.d/plugins/
```

### Enable QEmu aarch64 support

Install all support arch for qemu

```bash
$ curl -O https://raw.githubusercontent.com/qemu/qemu/master/scripts/qemu-binfmt-conf.sh
$ chmod +x qemu-binfmt-conf.sh
$ sudo ./qemu-binfmt-conf.sh --qemu-suffix "-static" --qemu-path /usr/bin
```

```bash
# mount /proc/sys/fs/binfmt_misc/ in docker container
mount -t binfmt_misc binfmt_misc /proc/sys/fs/binfmt_misc/
```

Make a startup script to enable qemu-support as root.

```bash
$ cat <<EOF > /etc/init.d/qemu-support
#!/usr/bin/env bash

### BEGIN INIT INFO
# Provides:          qemu-support
# Required-Start:    $remote_fs $syslog
# Required-Stop:     $remote_fs $syslog
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: qemu-support.
# Description:       qemu-support.
### END INIT INFO

/usr/bin/qemu-binfmt-conf.sh --qemu-suffix "-static" --qemu-path /usr/bin
EOF

$ ln -s /etc/init.d/qemu-support /etc/rc3.d/S99qemu-support

$ update-rc.d -f qemu-support defaults
$ update-rc.d -f qemu-support enable

```

### Fix

```bash
# for WSL2
$ sudo ln -s /proc/self/mounts /etc/mtab
```

If you use an SSD as boot device, you must to disable UASP over usb 3.0 with `usb-storage.quirks`.
You can use `008_disable_uasp_for_ssd.sh` script with `quirks` config.

```bash
# get id of SATA 6Gb/s bridge [VID]:[PID]
$ lsusb
Bus 002 Device 003: ID ****:**** JMicron Technology Corp. / JMicron USA Technology Corp. JMS561U two ports SATA 6Gb/s bridge
Bus 002 Device 001: ID ****:**** Linux Foundation 3.0 root hub
Bus 001 Device 004: ID ****:****
Bus 001 Device 002: ID ****:**** VIA Labs, Inc. Hub
Bus 001 Device 001: ID ****:**** Linux Foundation 2.0 root hub
```

```bash
# add in cmdline.txt
usb-storage.quirks=[VID]:[PID]:u
```

## raspi-config without GUI, full cmd line

Reboot after all nonint **boot** action !

```bash
# Update eeprom
$ sudo rpi-eeprom-update -d -a

# Update Pi
$ echo Y | sudo rpi-update

# https://github.com/RPi-Distro/raspi-config/blob/master/raspi-config
# Update to latest firmware
$ sudo raspi-config nonint do_update
# Prefere to use this cmd line to update raspi-config to avoid to run raspi-config gui
$ sudo apt-get update && sudo apt-get install raspi-config

# Select the latest firmware
# "E1 Latest" "Use the latest version boot ROM software"
# "E2 Default" "Use the factory default boot ROM software"
$ sudo raspi-config nonint do_boot_rom E1

# Set th usb boot to the first order, if you whant boot over SSD for example
# "B1 SD Card Boot" "Boot from SD Card if available, otherwise boot from USB"
# "B2 USB Boot" "Boot from USB if available, otherwise boot from SD Card"
# "B3 Network Boot" "Boot from network if SD card boot fails"
$ sudo raspi-config nonint do_boot_order B2

# Disable spash screen
$ sudo raspi-config nonint do_boot_splash 0

# Check current reserved GPU memory
$ sudo raspi-config nonint get_config_var gpu_mem /boot/config.txt

# Disable GPU (reduce)
$ sudo raspi-config nonint do_memory_split 16

# Set keyboard layout (en, de, fi, fr, hu, ja, nl, pt, ru, zh_CN)
$ sudo raspi-config nonint do_configure_keyboard en

# Set the timezone with raspi-config
# see https://en.wikipedia.org/wiki/List_of_tz_database_time_zones for the full list
$ sudo raspi-config nonint do_change_timezone Europe/Paris

# Set the Timezone (other method)
$ sudo timedatectl set-timezone Europe/Berlin
$ sudo timedatectl set-timezone Europe/Paris
$ sudo timedatectl set-timezone Europe/London
$ sudo timedatectl set-timezone America/New_York
$ sudo timedatectl set-timezone America/Los_Angeles
$ sudo timedatectl set-timezone Pacific/Auckland

# Set the local lang
# en_US.UTF-8, de_DE.UTF-8, fi_FI.UTF-8, fr_FR.UTF-8, hu_HU.UTF-8, ja_JP.UTF-8, nl_NL.UTF-8, pt_PT.UTF-8, ru_RU.UTF-8, zh_CN.UTF-8
# see https://docs.moodle.org/dev/Table_of_locales for the full list
$ sudo raspi-config nonint do_change_locale en_US.UTF-8
```

## Benchmark

```bash
$ sudo curl https://raw.githubusercontent.com/TheRemote/PiBenchmarks/master/Storage.sh | sudo bash
```

## Docker

```bash
# build
docker build . -t raspberry-cluster-tool
./wcluster.sh -h
```