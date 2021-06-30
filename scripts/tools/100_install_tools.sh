#!/usr/bin/env bash

set -e

if [[ ${CONFIG_INSTALL_TOOLS} != "" ]]; then
    apt-get update && apt-get install -y ${CONFIG_INSTALL_TOOLS} \
    && apt-get clean && rm -rf /var/lib/apt/lists/*
fi