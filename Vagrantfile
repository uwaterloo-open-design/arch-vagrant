# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANTFILE_API_VERSION = '2'

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.provider 'virtualbox' do |v|
    v.memory = 1024
    v.cpus = 2
  end

  config.vm.define 'arch-base' do |c|
    c.vm.box = 'jfredett/arch-base'
  end

  config.vm.define 'arch-chef' do |c|
    c.vm.box = 'jfredett/arch-chef'
  end

  config.vm.define 'arch-puppet' do |c|
    c.vm.box = 'jfredett/arch-puppet'
  end

  config.vm.define 'arch-chef-local' do |c|
    c.vm.box = 'arch-chef-local'
  end

  config.vm.define 'arch-puppet-local' do |c|
    c.vm.box = 'arch-puppet-local'
  end

end
