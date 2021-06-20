#!/usr/bin/env bash

set -e

if [[ ${PARAM_MAC_ADDR} != "" ]]; then
    echo "smsc95xx.macaddr=${PARAM_MAC_ADDR}" >> /boot/cmdline.txt
    cat /boot/cmdline.txt
fi