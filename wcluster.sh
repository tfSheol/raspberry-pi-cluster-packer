#!/usr/bin/env bash

set -e

docker run -it --rm --privileged --cap-add=ALL -v /dev:/dev \
--mount type=bind,source="$(pwd)"/output,target=/app/output \
--mount type=bind,source="$(pwd)"/packer_cache,target=/app/packer_cache \
--mount type=bind,source="$(pwd)"/.ssh,target=/app/.ssh,readonly \
--mount type=bind,source="$(pwd)"/.kube,target=/app/.kube,readonly \
raspberry-cluster-tool " $@ "