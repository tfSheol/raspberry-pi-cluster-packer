#!/usr/bin/env bash

set -e

if [[ ${PARAM_MAC_ADDR} != "" ]]; then
    config_file_content=$(cat /boot/cmdline.txt)
    echo "${config_file_content} smsc95xx.macaddr=${PARAM_MAC_ADDR}" > /boot/cmdline.txt
    cat /boot/cmdline.txt

#     apt-get update
#     apt-get install macchanger -y

#     apt-get clean && rm -rf /var/lib/apt/lists/*

#     cat <<EOF > /etc/network/if-up.d/macchange
#     #!/usr/bin/env bash

#     if [[ "\$IFACE" != lo ]]; then
#         /usr/bin/macchanger -m dc:a6:32:05:01:01 eth0
#     fi
# EOF
#     chmod +x /etc/network/if-up.d/macchange
#     cat /etc/network/if-up.d/macchange
fi