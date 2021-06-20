#!/usr/bin/env bash

set -e

if [[ ${PARAM_HOSTNAME} != "" ]]; then
    sed -i "s/raspberrypi/${PARAM_HOSTNAME}/g" /etc/hosts
    echo "${PARAM_HOSTNAME}" > /etc/hostname

    cat /etc/hosts
    cat /etc/hostname
fi