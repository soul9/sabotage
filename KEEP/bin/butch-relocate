#!/bin/sh

relocate() {
        local target_root=$1
        local dir=$2
        local backlinks=$3
        mkdir -p /$dir
        [ -d "$butch_install_dir/$dir" ] || return 0
        cd "$butch_install_dir/$dir" || return 1
        echo "relocating $butch_install_dir/$dir"
        for i in * ; do
                if [ -d "$i" ] ; then
                        local save="$PWD"
                        relocate "$target_root" "$dir/$i" "$backlinks/.."
                        cd "$save"
                elif [ -f "$i" ] || [ -L "$i" ] ; then
                        target="$target_root/$dir/$i"
                        echo "ln -sf $backlinks/$butch_install_dir/$dir/$i $target"
                        ln -sf "$backlinks/$butch_install_dir/$dir/$i" "$target"
                else
                        echo "UNKNOWN object $i"
                fi
        done
        echo "relocation done"
}

if [ -z "$1" ] ; then
	echo "tool to manually symlink a built package"
	echo "(i.e. the ones in /opt/packagename)"
	echo "into /"

	echo "error: need to pass directory to relocate"
	exit 1
fi

butch_root=/
butch_install_dir="$1"

for loc in bin sbin etc include lib libexec share var ; do
	relocate "$butch_root" $loc ..
done

