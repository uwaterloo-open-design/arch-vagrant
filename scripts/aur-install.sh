#!/bin/bash
d=${BUILDDIR:-$PWD}
for p in ${@##-*}; do
  echo "####### BUILDING $p ###########"
  cd $d
  curl https://aur.archlinux.org/packages/${p:0:2}/$p/$p.tar.gz > $p.tgz
  tar zxvf $p.tgz
  cd $p
  makepkg --noconfirm --needed -c ${@##[^\-]*}
done
