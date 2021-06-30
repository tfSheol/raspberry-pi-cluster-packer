#!/usr/bin/env bash

set -e

typeset -A config
typeset -A param

export CONFIG_ENV_LIST=""

#
# ex: setParam "config.file.name" "config.properties"
#
function setParam() {
    echo "= set param ${1} to ${2}"
    [[ ${1} = [\#!]* ]] || [[ ${1} = "" ]] || param[$1]=${2}
    VAR=${1^^}
    CONFIG_ENV+="\"PARAM_${VAR//./_}=${2}\", "
}

#
# ex: setConfig "test.name" "value"
#
# $ echo ${CONFIG_TEST_NAME}
# value
#
function setConfig() {
    if [[ "$2" =~ \[(.*)\] ]]; then
        value=${BASH_REMATCH[1]}
        storeConfigVariable "$1" "${value//,/ }"
    else
        storeConfigVariable "$1" "$2"
    fi
}

function storeConfigVariable() {
    echo "= set config ${1} to ${2}"
    [[ ${1} = [\#!]* ]] || [[ ${1} = "" ]] || config[$1]=${2}
    VAR=${1^^}
    CONFIG_ENV_LIST+="\$CONFIG_${VAR//./_} "
    CONFIG_ENV+="\"CONFIG_${VAR//./_}=${2}\", "
    export "CONFIG_${VAR//./_}=${2}"
}

function printDebug() {
    if [[ ${param['debug']} == "true" ]]; then
        echo
        echo ">> debug: $1"
        eval "${@:2}"
        echo
    fi
}

function printJsonDebug() {
    if [[ ${param['debug']} == "true" ]]; then
        echo
        echo ">> debug: $1"
        echo "$2" | jq
        echo
    fi
}

function checkNetwork() {
    echo
    echo ">> check connexion..."
    curl --silent --output /dev/null --location stackoverflow.com -i
    if [[ "$?" != 0 ]]; then
        echo >&2 "error: you need a network to work"
        exit -1
    fi
    echo "<< ok!"
}

function help() {
    echo
    echo "Usage: $0 {build <all|${config['boards']// /|}> | other} [options...]" >&2
    echo
    echo " options:"
    echo "    --working-directory=<...>         change current working directory"
    echo "    --config-path=<...>               change configuration file location path"
    echo "    --config-name=<...>               change configuration file name (current 'config.properties')"
    echo
    echo "    --enable-debug                    enable debug mode for $0"
    echo "    --enable-packer-log               enable packer extra logs"
    echo
    echo "    --mac-addr=<00:00:00:00:00:00>    set a custom mac addresse"
    echo "    --hostname=<test-423>             set a custom hostname"
    echo
    echo " cmd:"
    echo "    build                             build packer image <all|${config['boards']// /|}>"
    echo "    show ip                           list all raspberry pi ip + mac addresses of your local network"
    echo
    exit 1
}

# Default params config set
setParam "working.directory" "."
setParam "config.file.path" "."
setParam "config.file.name" "config.properties"
setParam "debug" "false"
setParam "increment" "1"

if [[ " $@ " =~ --working-directory=([^' ']+) ]]; then
    setParam "working.directory" ${BASH_REMATCH[1]}
fi

if [[ " $@ " =~ --config-path=([^' ']+) ]]; then
    setParam "config.file.path" ${BASH_REMATCH[1]}
fi

if [[ " $@ " =~ --config-name=([^' ']+) ]]; then
    setParam "config.file.name" ${BASH_REMATCH[1]}
fi

if [[ " $@ " =~ --mac-addr=(([0-9A-Fa-f]{2}[:-]){5}([0-9A-Fa-f]{2})) ]]; then
    setParam "mac.addr" ${BASH_REMATCH[1]}
fi

if [[ " $@ " =~ --hostname=([^' ']+) ]]; then
    setParam "hostname" ${BASH_REMATCH[1]}
fi

if [[ " $@ " =~ --increment=([0-9]+) ]]; then
    setParam "increment" ${BASH_REMATCH[1]}
fi

if [[ " $@ " =~ --enable-debug ]]; then
    setParam "debug" "true"
fi

if [[ " $@ " =~ --enable-packer-log ]]; then
    export PACKER_LOG=1
fi

if [[ " $@ " =~ --help ]]; then
    help
fi

if [[ ! -f ${param['config.file.path']}/${param['config.file.name']} ]]; then
    echo "error: ${param['config.file.path']}/${param['config.file.name']} not found!"
    exit -1
fi

config_file=$(cat "${param['config.file.path']}/${param['config.file.name']}")

for line in ${config_file// /}; do
    if [[ "$line" =~ (.*)\=(.*) ]]; then
        setConfig ${BASH_REMATCH[1]} ${BASH_REMATCH[2]}
    fi
done

if [[ " $@ " =~ --enable-custom-output ]]; then
    if [[ "${param['hostname']}" != "" && "${param['mac.addr']}" != "" ]]; then
        setConfig "raspios.image.output" "raspios-${param['hostname']}-${param['mac.addr']//:/-}.img"
    fi
fi

if [[ " $@ " =~ --skip-update ]]; then
    setConfig "id.scripts" "${config['id.scripts']//000 /}"
fi

if [[ " $@ " =~ --skip-all-scripts ]]; then
    setConfig "id.scripts" ""
fi

if [[ " $@ " =~ --skip-script=([0-9]+) ]]; then
    to_skip=${BASH_REMATCH[1]}
    setConfig "id.scripts" "${config['id.scripts']//$to_skip /}"
fi

# --skip-scripts=[001,100,102]
if [[ " $@ " =~ --skip-scripts=\[([^' ']+)\] ]]; then
    to_skips=${BASH_REMATCH[1]}
    for to_skip in ${to_skips//,/ }; do
        setConfig "id.scripts" "${config['id.scripts']//$to_skip /}"
    done
fi

if [[ " $@ " =~ --add-script=([0-9]+) ]]; then
    setConfig "id.scripts" "${config['id.scripts']} ${BASH_REMATCH[1]}"
fi

# --add-scripts=[001,100,102]
if [[ " $@ " =~ --add-scripts=\[([^' ']+)\] ]]; then
    to_adds=${BASH_REMATCH[1]}
    for to_add in ${to_adds//,/ }; do
        setConfig "id.scripts" "${config['id.scripts']} ${to_add}"
    done
fi

if [[ " $@ " =~ --kubespray ]]; then
    setConfig "id.scripts" "${config['id.scripts']} ${config['kubespray.id.scripts']}"
fi

if [[ " $@ " =~ --k0sproject ]]; then
    setConfig "id.scripts" "${config['id.scripts']} ${config['k0sproject.id.scripts']}"
fi

printDebug "Config file to env variables" "env | grep 'CONFIG_*'"

function packer() {
    echo ">> use configuration json file: ${config["${1}.config.file"]}"
    echo
    generated_json=$(envsubst "${CONFIG_ENV_LIST}" <boards/${config["${1}.config.file"]})
    generated_json=$(echo "$generated_json" |
        jq "(.provisioners[] | select(.script == \"scripts/bootstrap.sh\") | .environment_vars) = [${CONFIG_ENV::-2}]")
    printJsonDebug "Config JSON file" "$generated_json"
    echo $generated_json | sudo packer build -
}

checkNetwork

if [[ " $1 $2 " =~ ' build all ' ]]; then
    echo
    echo "build all"
    for board in ${config['boards']}; do
        echo "build $board"
        packer $board
    done
    exit 0
fi

if [[ " $1 $2 " =~ (build (${config['boards']// /|})) ]]; then
    final_increment_hostname=${param['hostname']:(-2)}
    final_increment_mac_addr=${param['mac.addr']:(-2)}
    img=${BASH_REMATCH[2]}
    for increment in $(seq 1 ${param['increment']}); do
        echo
        if [[ "${param['hostname']}" != "" && "${param['mac.addr']}" != "" && ${param['increment']} > 1 ]]; then
            echo ">> init increment: $increment"
            setParam "hostname" "${param['hostname']:0:(-1)}$(($final_increment_hostname+$increment))"
            setParam "mac.addr" "${param['mac.addr']:0:(-1)}$(($final_increment_mac_addr+$increment))"
            setConfig "raspios.image.output" "raspios-${param['hostname']}-${param['mac.addr']//:/-}.img"
        fi
        echo ">> build ${img} image"
        packer "${img}"
        done
    exit 0
fi

if [[ " $1 $2 " =~ ' show ip ' ]]; then
    echo
    if [[ $(uname -r) =~ WSL2$ ]]; then
        pi_ips=$(arp.exe -a | grep 'dc[-:]a6[-:]32[-:]*\|b8[-:]27[-:]eb[-:]*')
    else
        pi_ips=$(sudo arp-scan -l | grep 'dc[-:]a6[-:]32[-:]*\|b8[-:]27[-:]eb[-:]*')
    fi
    for pi_ip in ${pi_ips// /|}; do
        if [[ $pi_ip =~ ([0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3})(\|*)([0-9a-z]{1,2}[-:][0-9a-z]{1,2}[-:][0-9a-z]{1,2}[-:][0-9a-z]{1,2}[-:][0-9a-z]{1,2}[-:][0-9a-z]{1,2}) ]]; then
            ip=${BASH_REMATCH[1]}
            mac=${BASH_REMATCH[3]}
            if [[ $mac =~ dc[-:]a6[-:]32[-:].* ]]; then
                echo "pi4 version ip:<$ip> mac:<$mac>"
            else
                echo "older pi version ip:<$ip> mac:<$mac>"
            fi
        fi
    done
    exit 0
fi

help
