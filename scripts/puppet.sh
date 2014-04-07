#!/usr/bin/env bash

export BUILDDIR=/tmp
export PATH=/usr/local/bin:$PATH

sudo pacman -S --noconfirm ruby

# order matters here
deps="ruby-shadow ruby-facter ruby-json_pure ruby-hiera ruby-rgen ruby-hiera-json"
for pkg in $deps; do
  echo "*** INSTALLING $pkg"
  aur-install -i $pkg
done

aur-install -i puppet
