require 'rubygems'

namespace :iso do
  def mirror
    'http://mirror.rit.edu/archlinux/iso'
  end

  def date
    '2014.03.01'
  end

  file 'templates/base.iso' do
    system "wget #{mirror}/#{date}/archlinux-#{date}-dual.iso     -O templates/base.iso"
  end
  file 'templates/base.iso.sig' do
    system "wget #{mirror}/#{date}/archlinux-#{date}-dual.iso.sig -O templates/base.iso.sig"
  end

  task :verify => ['templates/base.iso', 'templates/base.iso.sig'] do
    system 'gpg --verify templates/base.iso.sig templates/base.iso'
  end

  task :md5 => ['templates/base.iso'] do
    system 'md5sum --tag templates/base.iso'
  end
end
task :iso => :'iso:verify'
