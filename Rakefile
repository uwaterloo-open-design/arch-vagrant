require 'rubygems'

task :verify_iso do
  system 'gpg --verify templates/base.iso.sig templates/base.iso'
end

task :md5_iso do
  system 'md5sum --tag templates/base.iso'
end

task :download_iso do
  mirror = 'http://mirror.rit.edu/archlinux/iso'
  date = '2014.03.01'

  system "wget #{mirror}/#{date}/archlinux-#{date}-dual.iso     -O templates/base.iso"
  system "wget #{mirror}/#{date}/archlinux-#{date}-dual.iso.sig -O templates/base.iso.sig"
end

