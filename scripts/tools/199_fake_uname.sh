#!/usr/bin/env bash

set -e

cat <<EOF > /tmp/uname
#!/usr/bin/env bash

# Tool to fake the output in chroot to adjust the
# used kernel version in different Makefiles.
# credit: https://github.com/brenkem/fake-uname/blob/master/uname

# prepare system by rehash uname from /bin/uname
# to /tmp/uname: "hash -p /tmp/uname uname"

# A POSIX variable
OPTIND=1         # Reset in case getopts has been used previously in the shell.

if [ \$# -eq 0 ]; then
	/bin/uname
fi

while getopts "asnrvmpio" opt; do
	case "\$opt" in
		### -m ==================================================================
		#### return machine arch of an arm hard floating platform
		m) echo amd64
		;;

		# default: just use original to provide output
		# currently only working with a single option on the command call
		*) /bin/uname -\$opt
		;;
	esac
done

EOF

chmod +x /tmp/uname

hash -p /tmp/uname uname

echo "=== test custom uname -m, result wanted: \"amd64\" ==="

uname -m