require 'rubygems'

namespace :iso do
  task :verify do
    system 'gpg --verify templates/base.iso.sig templates/base.iso'
  end

  task :md5 do
    system 'md5sum --tag templates/base.iso'
  end

  task :download do
    mirror = 'http://mirror.rit.edu/archlinux/iso'
    date = '2014.03.01'

    system "wget #{mirror}/#{date}/archlinux-#{date}-dual.iso     -O templates/base.iso"
    system "wget #{mirror}/#{date}/archlinux-#{date}-dual.iso.sig -O templates/base.iso.sig"
  end
end
