#!/usr/bin/env bash

set -e

if [[ ${PARAM_MAC_ADDR} != "" ]]; then
    config_file_content=$(cat /boot/cmdline.txt)
    echo "${config_file_content} smsc95xx.macaddr=${PARAM_MAC_ADDR}" > /boot/cmdline.txt
    cat /boot/cmdline.txt
fi