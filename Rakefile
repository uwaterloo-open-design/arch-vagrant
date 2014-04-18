require 'rubygems'
require 'aws-sdk'


# load the AWS credentials
load './aws-credentials'
CONFIG = YAML.load_file('version.yml')

def find_box_definition(box)
  box =~ %r{boxes/([^\.]*)\.box}
  ["packer/#{$1}.json", 'boxes']
end

CLEAN = FileList.new
DIST  = FileList.new
NUKE  = FileList.new

require './lib/iso'
require './lib/upload'

task :clean do
  sh "rm -rf #{CLEAN}"
end
task :distclean => :clean do
  sh "rm -rf #{DIST}"
end
task :nuke => :distclean do
  sh "rm -rf #{NUKE}"
end

directory 'boxes'
directory 'templates'
directory 'packer'
directory 'scripts'

file 'version'

# packer-> script dependencies
file 'scripts/chef.sh'
file 'scripts/puppet.sh'
file 'scripts/base.sh'
file 'scripts/aur-install.sh'

PACKER_FILES = ['packer', 'version.yml']
file 'packer/arch-chef.json'   => PACKER_FILES + ['scripts/chef.sh', 'scripts/aur-install.sh']
file 'packer/arch-puppet.json' => PACKER_FILES + ['scripts/puppet.sh', 'scripts/aur-install.sh']
file 'packer/arch-base.json'   => PACKER_FILES + ['scripts/base.sh', 'scripts/aur-install.sh']

rule %r{packer/[^\.]*\.json} do |t|
  sh "touch #{t.name}" # update this file if any of it's dependencies update
end

DIST.include('boxes/*.box')
rule %r{boxes/[^\.]*\.box} => proc { |box| find_box_definition box } do |t|
  sh "packer validate #{t.source}"
  sh "packer build -force #{t.source}"
end

OVF_FILES = FileList['boxes/packer-virtualbox-iso-disk1.vmdk', 'boxes/arch-base.ovf']

CLEAN.include('boxes/arch-base.ovf')
file 'boxes/arch-base.ovf' => 'boxes/arch-base.box' do
  sh 'tar xf boxes/arch-base.box box.ovf'
  sh 'mv box.ovf boxes/arch-base.ovf'
  sh 'touch boxes/arch-base.ovf' # the timestamp will be wrong if it's not updated
end

CLEAN.include('boxes/packer-virtualbox-iso-disk1.vmdk')
file 'boxes/packer-virtualbox-iso-disk1.vmdk' => 'boxes/arch-base.box' do
  sh 'tar xf boxes/arch-base.box packer-virtualbox-iso-disk1.vmdk'
  sh 'mv packer-virtualbox-iso-disk1.vmdk boxes/packer-virtualbox-iso-disk1.vmdk'
  sh 'touch boxes/packer-virtualbox-iso-disk1.vmdk' # the timestamp will be wrong if it's not updated
end

file 'boxes/arch-chef.box' => OVF_FILES + ['packer/arch-chef.json']
file 'boxes/arch-puppet.box' => OVF_FILES

task default: ['boxes/arch-chef.box', 'boxes/arch-puppet.box']
