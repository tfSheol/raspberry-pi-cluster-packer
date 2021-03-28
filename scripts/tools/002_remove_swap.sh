#!/usr/bin/env bash

set -e

sed -i 's|CONF_SWAPSIZE=.*|CONF_SWAPSIZE=0|' /etc/dphys-swapfile
systemctl disable dphys-swapfile