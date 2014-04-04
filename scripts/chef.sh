#!/usr/bin/env bash

cat<<SCRIPT >/tmp/aur-install
#!/bin/bash
d=\${BUILDDIR:-\$PWD}
for p in \${@##-*}; do
  cd \$d
  curl https://aur.archlinux.org/packages/\${p:0:2}/\$p/\$p.tar.gz > \$p.tgz
  tar zxvf \$p.tgz
  cd \$p
  makepkg \${@##[^\-]*}
done
SCRIPT
chmod a+x /tmp/aur-install
sudo mv /tmp/aur-install /usr/local/bin/aur-install

sudo pacman -S --noconfirm ruby git
aur-install --noconfirm --needed -i ruby-bundler
sudo aur-install --noconfirm --needed --asroot -i omnibus-chef || true

echo 'export PATH=/opt/chef/bin:$PATH' > .bashrc
