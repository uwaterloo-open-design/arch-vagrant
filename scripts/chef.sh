#!/usr/bin/env bash

export BUILDDIR=/tmp
export PATH=/usr/local/bin:$PATH

sudo pacman -S --noconfirm ruby git base-devel
aur-install --noconfirm -i ruby-bundler
aur-install --noconfirm -i chef-dk
