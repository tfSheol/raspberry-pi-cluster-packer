#!/usr/bin/env bash

set -e

for script in $(ls -1 /tmp/tools); do
    echo "--------------------------------------------"
    echo ">> exec ${script}"
    echo "--------------------------------------------"
    source /tmp/tools/${script}
done

exit 0