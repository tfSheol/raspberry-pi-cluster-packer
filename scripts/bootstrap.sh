#!/usr/bin/env bash

set -e

env

for script in $(ls -1 /tmp/tools); do
    echo ">> exec ${script}"
    source /tmp/tools/${script}
done