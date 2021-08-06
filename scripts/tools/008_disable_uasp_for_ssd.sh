#!/usr/bin/env bash

set -e

config_file_content=$(cat /boot/cmdline.txt)
echo "${config_file_content} usb-storage.quirks=${CONFIG_QUIRKS}" > /boot/cmdline.txt
cat /boot/cmdline.txt