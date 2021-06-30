#!/usr/bin/env bash

set -e

CONFIG_ID_SCRIPTS=${CONFIG_ID_SCRIPTS#"${CONFIG_ID_SCRIPTS%%[! ]*}"}

if [[ ${CONFIG_ID_SCRIPTS} != "" ]]; then
    for script in $(ls -1 /tmp/tools | grep "${CONFIG_ID_SCRIPTS// /\\\|}"); do
        echo "--------------------------------------------"
        echo ">> exec ${script}"
        echo "--------------------------------------------"
        source /tmp/tools/${script}
    done
fi

exit 0