#!/bin/sh

if [ -z "$1" ] ; then
	echo "error: expecting directory name to apply root perms"
	exit 1
fi

if [ ! -e "$1"/src/config ] ; then
	echo "error: $1 doesn't look like a sabotage rootfs"
	exit 1
fi	

for dir in / etc bin boot home include info lib libexec mnt root sbin share src srv sys tmp usr var ; do
        chown -R root:root "$1"/$dir
done
chmod 0755 var/empty
