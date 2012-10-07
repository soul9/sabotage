#!/bin/sh
# call this in case you encountered a build problem during stage0, which you fixed.
# this will continue where you left.
# in case you modified pkg/ or KEEP/ you'll have to copy it to $S/

$S/butch.bin install stage0
