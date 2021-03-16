## Full install for WSL2 or other linux

### Install QEmu & dependencies

```bash
$ sudo apt install qemu binfmt-support qemu-user-static
$ sudo update-binfmts --display
```

### Install packer 1.7.0 or more

```bash
$ wget https://releases.hashicorp.com/packer/1.7.0/packer_1.7.0_linux_amd64.zip
$ unzip packer_1.7.0_linux_amd64.zip
$ sudo mv packer /usr/local/bin/
```

### Install ARM builder plugin for packer (1.7.0 fix api)

```bash
$ git clone https://github.com/mkaczanowski/packer-builder-arm
$ cd packer-builder-arm
$ go mod download
$ go build

$ sudo cp packer-builder-arm ~/.packer.d/plugins/
$ sudo mkdir -p /root/.packer.d/plugins/
$ sudo cp packer-builder-arm /root/.packer.d/plugins/
```

### Enable QEmu aarch64 support

```bash
$ sudo update-binfmts --install arm /usr/bin/qemu-aarch64-static --magic '\x7fELF\x01\x01\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x02\x00\x28\x00' --mask '\xff\xff\xff\xff\xff\xff\xff\x00\xff\xff\xff\xff\xff\xff\xff\xff\xfe\xff\xff\xff'
```

### Fix WSL2

```bash
$ sudo ln -s /proc/self/mounts /etc/mtab
```

## Usage

```bash
$ ./build.sh

// or
$ sudo packer build boards/ubuntu_server_20.10_arm64.json
```