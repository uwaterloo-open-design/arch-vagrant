require 'rubygems'
require './lib/iso'

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

namespace :vagrant do
  namespace :add do
    task :raw do
      system 'vagrant box add --force arch-raw-local boxes/arch-raw.box'
    end
  end

  namespace :rm do
    task :raw do
      system 'vagrant box remove arch-raw-local'
    end
  end

  task :add => [:"vagrant:add:raw"]
  task :rm => [:"vagrant:rm:raw"]

  task :up, [:box] do |_, args|
    system "vagrant up arch-#{args[:box]}"
  end

  task :destroy, [:box] do |_, args|
    system "vagrant destroy -f arch-#{args[:box]}"
  end
  namespace :destroy do
    task :all do
      system 'rake vagrant:destroy[base]'
      system 'rake vagrant:destroy[chef]'
      system 'rake vagrant:destroy[puppet]'
    end
  end

  task :cycle, [:box] do |_, args|
    system "rake vagrant:destroy[#{args[:box]}] vagrant:up[#{args[:box]}]"
  end

  task :export, [:box] do |_, args|
    system "vagrant package arch-#{args[:box]} --output boxes/arch-#{args[:box]}"
  end
  namespace :export do
    task :all do
      system 'rake vagrant:export[base]'
      system 'rake vagrant:export[chef]'
      system 'rake vagrant:export[puppet]'
    end
  end

  task :ssh, [:box] do |_, args|
    system "vagrant ssh arch-#{args[:box]}"
  end
end

namespace :packer do
  task :gen do
    system 'rm -f boxes/arch-raw.box'
    system 'packer build archbox.json'
  end
end

task :rebuild => [
  :"vagrant:destroy:all",
  :"vagrant:rm",
  :"packer:gen",
  :"vagrant:add"
]
