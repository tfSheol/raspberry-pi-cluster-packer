FROM mkaczanowski/packer-builder-arm

ENV DIR /app

WORKDIR $DIR
COPY . $DIR

RUN apt-get update && apt-get install -y \
  gettext-base curl wget jq qemu-user-static && \
  apt-get clean && rm -rf /var/cache/apt/* && rm -rf /var/lib/apt/lists/* RUN rm -rf /tmp/*

ENTRYPOINT ["/bin/bash", "./entrypoint.sh"]
CMD ["-h"]