#!/usr/bin/env bash

set -e

docker run -it --rm --cap-add ALL --privileged --device-cgroup-rule="b 7:* rmw" \
--device=/dev/loop-control:/dev/loop-control \
--device=/dev/mapper/control:/dev/mapper/control \
--device=/dev/loop0:/dev/loop0 \
--device=/dev/loop1:/dev/loop1 \
--device=/dev/loop2:/dev/loop2 \
--device=/dev/loop3:/dev/loop3 \
--device=/dev/loop4:/dev/loop4 \
--mount type=bind,source=/var/run/docker.sock,target=/var/run/docker.sock,readonly \
--mount type=bind,source="$(pwd)"/output,target=/app/output \
--mount type=bind,source="$(pwd)"/packer_cache,target=/app/packer_cache \
--mount type=bind,source="$(pwd)"/.ssh,target=/app/.ssh,readonly \
--mount type=bind,source="$(pwd)"/.kube,target=/app/.kube,readonly \
raspberry-cluster " $@ "