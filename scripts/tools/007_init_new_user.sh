#!/usr/bin/env bash

set -e

if [[ ${CONFIG_SYSTEM_USER} != "pi" ]]; then
  useradd -m -s /usr/bin/bash ${CONFIG_SYSTEM_USER}
  groupadd ${CONFIG_SYSTEM_USER}
  echo "${CONFIG_SYSTEM_USER_PASSWORD}" | passwd "${CONFIG_SYSTEM_USER}" --stdin
fi