require 'rubygems'

namespace :iso do
  def arch
    "#{CONFIG['iso']['mirror']}/#{CONFIG['iso']['date']}/archlinux-#{CONFIG['iso']['date']}-dual"
  end

  directory 'templates'

  NUKE.include('templates/base.iso')
  file 'templates/base.iso' => 'templates' do
    sh "wget #{arch}.iso -O templates/base.iso"
  end

  NUKE.include('templates/base.iso.sig')
  file 'templates/base.iso.sig' => 'templates' do
    sh "wget #{arch}.iso.sig -O templates/base.iso.sig"
  end

  NUKE.include('templates/verified')
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
