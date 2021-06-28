## Full install for WSL2 or other linux

### Startup

```bash
$ ./cluster.sh build raspios --enable-debug --mac-addr=dc:a6:32:01:01:01 --hostname=pi-010101 --enable-custom-output
$ ls -1
raspios-pi-010101-dc-a6-32-01-01-01.img
```

```bash
$ ./cluster.sh build raspios --enable-debug --mac-addr=dc:a6:32:01:01:00 --hostname=pi-010100 --enable-custom-output --increment=4
$ ls -1
raspios-pi-010101-dc-a6-32-01-01-01.img
raspios-pi-010102-dc-a6-32-01-01-02.img
raspios-pi-010103-dc-a6-32-01-01-03.img
raspios-pi-010104-dc-a6-32-01-01-04.img
```

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

```bash
$ sudo update-binfmts --install arm /usr/bin/qemu-aarch64-static --magic '\x7fELF\x01\x01\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x02\x00\x28\x00' --mask '\xff\xff\xff\xff\xff\xff\xff\x00\xff\xff\xff\xff\xff\xff\xff\xff\xfe\xff\xff\xff'
$ sudo update-binfmts --enable qemu-aarch64
```

## Usage

```bash
$ ./cluster.sh
= set param working.directory to .
= set param config.file.path to .
= set param config.file.name to config.properties
= set param debug to false
= set config boards to raspios ubuntu
= set config image.size to 4.5G
= set config image.type to dos
= set config packer.type to arm
= set config qemu.binary to qemu-aarch64-static
= set config raspios.config.file to raspios_lite_arm64.json
= set config raspios.arch to arm64
= set config raspios.version to 2020-08-24
= set config raspios.file to 2020-08-20-raspios-buster-arm64-lite
= set config raspios.image.output to raspios_lite_arm64.img
= set config ubuntu.config.file to ubuntu_server_20.10_arm64.json
= set config ubuntu.output to ubuntu-20.04.img
= set config ubuntu.arch to arm64
= set config ubuntu.version to 20.10
= set config ubuntu.file to ubuntu-20.10-preinstalled-server-arm64+raspi

Usage: ./cluster.sh {build <all|raspios|ubuntu> | other} [options...]

 options:
    --working-directory=<...>       change current working directory
    --config-path=<...>             change configuration file location path
    --config-name=<...>             change configuration file name (current 'config.properties')

    --enable-debug                  enable debug mode for ./cluster.sh
    --enable-packer-log             enable packer extra logs

 cmd:
    build                           build packer image <all|raspios|ubuntu>
```

### Config

```properties
boards=[raspios, ubuntu]

# Global
# ${CONFIG_}
image.size=4.5G
image.type=dos
packer.type=arm
qemu.binary=qemu-aarch64-static

# Raspios
# ${CONFIG_RASPIOS_}
raspios.config.file=raspios_lite_arm64.json
raspios.arch=arm64
raspios.version=2020-08-24
raspios.file=2020-08-20-raspios-buster-arm64-lite
raspios.image.output=raspios_lite_arm64.img

# Ubuntu server
# ${CONFIG_UBUNTU_}
ubuntu.config.file=ubuntu_server_20.10_arm64.json
ubuntu.output=ubuntu-20.04.img
ubuntu.arch=arm64
ubuntu.version=20.10
ubuntu.file=ubuntu-20.10-preinstalled-server-arm64+raspi
```

## Fix

```bash
# for WSL2
$ sudo ln -s /proc/self/mounts /etc/mtab
```

```bash
$ sudo update-binfmts --display
arm (enabled):
     package = <local>
        type = magic
      offset = 0
       magic = \x7fELF\x01\x01\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x02\x00\x28\x00
        mask = \xff\xff\xff\xff\xff\xff\xff\x00\xff\xff\xff\xff\xff\xff\xff\xff\xfe\xff\xff\xff
 interpreter = /usr/bin/qemu-aarch64-static
    detector =
cli (disabled):
     package = mono-runtime
        type = magic
      offset = 0
       magic = MZ
        mask =
 interpreter = /usr/bin/cli
    detector = /usr/lib/cli/binfmt-detector-cli
i386 (disabled):
     package = <local>
        type = magic
      offset = 0
       magic = \x7fELF\x01\x01\x01\x03\x00\x00\x00\x00\x00\x00\x00\x00\x03\x00\x03\x00\x01\x00\x00\x00
        mask = \xff\xff\xff\xff\xff\xff\xff\xfc\xff\xff\xff\xff\xff\xff\xff\xff\xf8\xff\xff\xff\xff\xff\xff\xff
 interpreter = /usr/local/bin/qemu-i386
    detector =
jar (disabled):
     package = openjdk-11
        type = magic
      offset = 0
       magic = PK\x03\x04
        mask =
 interpreter = /usr/bin/jexec
    detector =
python2.7 (disabled):
     package = python2.7
        type = magic
      offset = 0
       magic = \x03\xf3\x0d\x0a
        mask =
 interpreter = /usr/bin/python2.7
    detector =
python3.8 (disabled):
     package = python3.8
        type = magic
      offset = 0
       magic = \x55\x0d\x0d\x0a
        mask =
 interpreter = /usr/bin/python3.8
    detector =
python3.9 (disabled):
     package = python3.9
        type = magic
      offset = 0
       magic = \x61\x0d\x0d\x0a
        mask =
 interpreter = /usr/bin/python3.9
    detector =
qemu-aarch64 (enabled):
     package = qemu-user-static
        type = magic
      offset = 0
       magic = \x7f\x45\x4c\x46\x02\x01\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x02\x00\xb7\x00
        mask = \xff\xff\xff\xff\xff\xff\xff\x00\xff\xff\xff\xff\xff\xff\xff\xff\xfe\xff\xff\xff
 interpreter = /usr/libexec/qemu-binfmt/aarch64-binfmt-P
    detector =
```