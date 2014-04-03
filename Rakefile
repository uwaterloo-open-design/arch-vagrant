require 'rubygems'
require 'aws-sdk'

require './lib/iso'
require './lib/rules'
require './lib/upload'
require './lib/helpers'

# load the AWS credentials
load './aws-credentials'

directory 'boxes'
file FileList['scripts/*']
file 'version'

file 'archbox.json' => 'scripts/provision.sh'

file 'boxes/arch-base.box' => ['boxes', 'archbox.json', 'version', 'templates/base.iso'] do
  sh 'rm -f boxes/arch-base.box'
  sh 'vagrant box remove arch-base-local'
  sh 'packer build archbox.json'
  sh 'vagrant box add arch-base-local boxes/arch-base.box'
end

file 'boxes/arch-chef.box' => ['scripts/chef.sh', 'boxes/arch-base.box']
file 'boxes/arch-puppet.box' => ['scripts/puppet.sh', 'boxes/arch-base.box']

task default: ['boxes/arch-chef.box', 'boxes/arch-puppet.box']
