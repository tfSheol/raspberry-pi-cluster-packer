#!/usr/bin/env bash

set -e

mkdir -p /etc/init.d/script

cat <<EOF > /etc/init.d/script/bootstrap.sh
#!/usr/bin/env bash
for script in \$(ls -1 /opt/startup); do
    echo "--------------------------------------------"
    echo ">> [first boot script] exec ${script}"
    echo "--------------------------------------------"
    source /opt/startup/${script}
    echo ">> init : \"/opt/startup/${script}\"" >> /opt/startup/startup.log
done
rm $0
EOF

chmod +x /etc/init.d/script/bootstrap.sh