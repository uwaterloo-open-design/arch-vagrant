require 'rubygems'

namespace :iso do
  def arch
    "#{CONFIG['iso']['mirror']}/#{CONFIG['date']}/archlinux-#{CONFIG['date']}-dual"
  end

  directory 'templates'

  file 'templates/base.iso' => 'templates' do
    sh "wget #{arch}.iso -O templates/base.iso"
  end

  file 'templates/base.iso.sig' => 'templates' do
    sh "wget #{arch}.iso.sig -O templates/base.iso.sig"
  end

  file 'templates/verified' => ['templates/base.iso', 'templates/base.iso.sig'] do
    sh 'gpg --verify templates/base.iso.sig templates/base.iso > templates/verified'
  end

  desc 'calculate the md5sum of the base.iso'
  task :md5 => ['templates/base.iso'] do
    sh 'md5sum --tag templates/base.iso'
  end
end

desc 'download and verify the base iso'
multitask :iso => :'templates/verified'
