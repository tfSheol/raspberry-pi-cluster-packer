#!/usr/bin/env bash

set -e

mkdir -p /etc/init.d/script

cat <<EOF > /etc/init.d/bootstrap
#!/usr/bin/env bash

### BEGIN INIT INFO
# Provides:          bootstrap
# Required-Start:    $remote_fs $syslog
# Required-Stop:     $remote_fs $syslog
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: Init pi with startup scripts.
# Description:       Init pi with startup scripts.
### END INIT INFO

mkdir -p /opt/startup

exec 1>>/opt/startup/startup.log
exec 2>&1

for script in \$(ls -1 /opt/startup/*.sh); do
    echo "--------------------------------------------"
    echo ">> [first boot script] exec \${script}"
    echo "--------------------------------------------"
    source \${script}
    echo "================ end \${script} ======================="
done
update-rc.d -f bootstrap disable
EOF

chmod +x /etc/init.d/bootstrap

update-rc.d -f bootstrap defaults
update-rc.d -f bootstrap enable