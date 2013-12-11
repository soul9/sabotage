#!/bin/sh
# use like: cat pkg/* | utils/extract-links.sh | utils/check-downloads.sh
while read p ; do
	wget --spider --timeout 60 -q "$p" || echo "$p"
done
