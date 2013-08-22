#!/bin/sh

# put your custom cflags and ldflags here...
# this file is sourced by the default butch build template

isgcc3() {
	local mycc="$CC"
	[ -z "$mycc" ] && mycc=gcc
	"$mycc" --version | grep "3.4.6" >/dev/null
}

if [ "$DEBUGBUILD" = "1" ] ; then
	# use "DEBUGBUILD=1 butch install mypkg" to create debug version of mypkg
	optcflags="-O0 -g3"
	optldflags=
else
	# STAGE is set to 0 by config.stage0, and to 1 by config.stage1
	if [ "$STAGE" = "0" ] || isgcc3 ; then
		# stage 0 is built with the hostcompiler until stage0_gcc, after that using gcc3
		# so cflags should be more conservative - gcc 3 does not support lto and similar options.
		optcflags="-fdata-sections -ffunction-sections -Os -g0 -fno-unwind-tables -fno-asynchronous-unwind-tables"
	else
		# lto usually gives better results in speed and size than forced functionsections + garbage collection
		# however it's like 10 times slower.
		# so you should enable it only if build time does not matter and you want the best possible result.
		# optcflags="-flto -fwhole-program -Os -g0"
		optcflags="-ftree-dce -fdata-sections -ffunction-sections -Os -g0 -fno-unwind-tables -fno-asynchronous-unwind-tables"
	fi
	optldflags="-s -Wl,--gc-sections -Wl,-z,relro,-z,now"
fi

