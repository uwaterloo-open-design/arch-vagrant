#!/usr/bin/env bash
echo 'Make filesystems.'
mkfs.btrfs /dev/sda1
mkfs.btrfs /dev/sda2

echo 'Mount virtual drives'
mkdir -p /mnt
mount /dev/sda2 /mnt
mkdir -p /mnt/boot
mount /dev/sda1 /mnt/boot

echo 'Bootstrap the base system'
pacstrap /mnt base base-devel

echo 'Generate an fstab'
genfstab -U -p /mnt >> /mnt/etc/fstab

/bin/arch-chroot /mnt <<SCRIPT

echo 'Setting locale information'

echo 'en_US.UTF-8 UTF-8' > /etc/locale.gen
locale-gen
echo LANG=en_US.UTF-8 > /etc/locale.con

echo 'Set the HW Clock'
hwclock --systohc --utc

echo 'Set up the initial RAMdisk'
mkinitcpio -p linux

echo 'Ensure dhcpcd starts on boot'
systemctl enable dhcpcd.service

echo Create 'vagrant' user
useradd vagrant
mkdir /home/vagrant
mkdir /home/vagrant/.ssh
echo vagrant:vagrant | chpasswd

echo 'Fix permissions on vagrant keys.'
chown -R vagrant /home/vagrant/.ssh/
chmod 700 /home/vagrant/.ssh/
chmod 600 /home/vagrant/.ssh/authorized_keys

echo 'Install bootloader'
pacman --noconfirm -S syslinux
syslinux-install_update -i -a -m

echo 'Fix syslinux config'
sed s/sda3/sda1/ /boot/syslinux/syslinux.cfg | tee /boot/syslinux/syslinux.cfg

SCRIPT
