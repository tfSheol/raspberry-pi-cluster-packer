#!/usr/bin/env bash

set -e

config_file_content=$(cat /boot/cmdline.txt)
echo "${config_file_content} cgroup_enable=cpuset cgroup_enable=memory cgroup_memory=1" > /boot/cmdline.txt
cat /boot/cmdline.txt