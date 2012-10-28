#!/bin/sh
this=$PWD
tmp=/tmp/musl-git.000
giturl=git://git.etalabs.net/musl
commit=86dd1e7bbb1e0901b7f07ed41be5dc98fd39f5ef

getfilesize() {
        wc -c "$1" | cut -d ' ' -f 1
}

gethash() {
        sha512sum "$1" | cut -d ' ' -f 1
}

mkdir -p $tmp
(
cd $tmp
git clone $giturl musl-git || exit 1
cd musl-git || exit 1
[ -z $commit ] || git checkout $commit
rm -rf ".git"
cd ..
tar czf musl-git.tar.gz musl-git/
cp musl-git.tar.gz $this/tarballs || exit 1
)
rm -rf "$tmp"

echo filesize=$(getfilesize $this/tarballs/musl-git.tar.gz)
echo sha512=$(gethash $this/tarballs/musl-git.tar.gz)

