FROM debian:bookworm

ENV DIR /app

RUN apt-get update && apt-get install -y qemu qemu-user qemu-user-static binfmt-support \
  qemu-utils qemu-efi-aarch64 qemu-system-arm git kmod e2fsprogs \
  gettext-base parted curl wget unzip golang-go jq e2fsprogs dosfstools libarchive-tools && \
  apt-get clean && rm -rf /var/cache/apt/* && rm -rf /var/lib/apt/lists/*

RUN cd /tmp && wget https://releases.hashicorp.com/packer/1.7.0/packer_1.7.0_linux_amd64.zip && \
  unzip packer_1.7.0_linux_amd64.zip && \
  mv packer /usr/local/bin/

RUN cd /tmp && git clone https://github.com/SwampDragons/packer-builder-arm && \
  cd packer-builder-arm && \
  go mod download && \
  go build && \
  mkdir -p /root/.packer.d/plugins/ && \
  cp packer-builder-arm /root/.packer.d/plugins/

RUN rm -rf /tmp/*

WORKDIR $DIR
COPY . $DIR

ENTRYPOINT ["/bin/bash", "-c"]
# ENTRYPOINT ["/bin/bash", "./cluster.sh"]
# CMD ["-h"]