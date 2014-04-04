
#!/usr/bin/env bash


cat<<SCRIPT >/tmp/aur-install
#!/bin/bash
d=\${BUILDDIR:-\$PWD}
for p in \${@##-*}; do
  cd \$d
  echo "Downloading \$p"
  curl -s https://aur.archlinux.org/packages/\${p:0:2}/\$p/\$p.tar.gz -o \$p.tgz
  tar xf \$p.tgz
  cd \$p
  makepkg -c --noprogressbar --noconfirm \${@##[^\-]*}
done
SCRIPT
chmod a+x /tmp/aur-install
sudo mv /tmp/aur-install /usr/local/bin/aur-install

export BUILDDIR=/tmp

sudo pacman -S --noconfirm ruby

# order matters here
deps="ruby-shadow ruby-facter ruby-json_pure ruby-hiera ruby-rgen ruby-hiera-json"
for pkg in $deps; do
  echo "*** INSTALLING $pkg"
  aur-install -i $pkg
done

aur-install -i puppet
