#!/usr/bin/env bash

set -e

apt-get update && apt-get install -y arp-scan \
&& apt-get clean && rm -rf /var/lib/apt/lists/*

cd /usr/share/arp-scan
get-iab -v -u http://standards.ieee.org/develop/regauth/iab/iab.txt
get-oui -v -u http://standards.ieee.org/develop/regauth/oui/oui.txt

# sudo arp-scan -l | grep "Raspberry Pi"
# 192.168.1.15   b8:27:eb:00:00:00       Raspberry Pi Foundation # <pi4
# 192.168.1.17   dc:a6:32:00:00:00       Raspberry Pi Trading Ltd # >=pi4

# DC-A6-32	DC-A6-32-00-00-00 - DC-A6-32-FF-FF-FF	Raspberry Pi Trading Ltd
# B8-27-EB	B8-27-EB-00-00-00 - B8-27-EB-FF-FF-FF	Raspberry Pi Foundation