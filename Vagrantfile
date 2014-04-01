# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANTFILE_API_VERSION = '2'

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.ssh.private_key_path = 'keys/vagrant'

  config.vm.define 'arch-base' do |c|
    c.vm.box = 'arch-raw-local'
  end

  #config.vm.define 'arch-chef' do |c|
    #c.vm.box = 'arch-base-local'

    #c.vm.provision :shell do |shell|

    #end
  #end

  #config.vm.define 'arch-puppet' do |c|
    #c.vm.box = 'arch-base-local'

    #c.vm.provision :shell do |shell|

    #end
  #end
end
