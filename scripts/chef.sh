#!/usr/bin/env bash

export BUILDDIR=/tmp
export PATH=/usr/local/bin:$PATH

sudo pacman -S --noconfirm ruby git base-devel
aur-install --noconfirm -i ruby-bundler
sudo aur-install --asroot --noconfirm -f omnibus-chef-git

# set up /etc/profile w/ the fixed PATH
cp /etc/profile /tmp/profile
echo 'export "PATH=/opt/chef/bin:$PATH"' >> /tmp/profile
sudo mv /tmp/profile /etc/profile
