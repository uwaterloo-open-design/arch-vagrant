#!/usr/bin/env bash

export BUILDDIR=/tmp
export PATH=/usr/local/bin:$PATH

sudo pacman -S --noconfirm ruby git base-devel
aur-install -i ruby-bundler
sudo aur-install --asroot omnibus-chef

# running w/ -i will result in a confirmation screen. No bueno.
/usr/local/sbin/chef-installer

echo 'export PATH=/opt/chef/bin:$PATH' > .bashrc

