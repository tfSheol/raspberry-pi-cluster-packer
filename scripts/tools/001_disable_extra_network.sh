#!/usr/bin/env bash

set -e

systemctl disable dhcpcd
systemctl disable wpa_supplicant
systemctl disable bluetooth