require 'rubygems'
require 'aws-sdk'
require './lib/iso'

load './aws-credentials'

directory 'boxes'

file FileList['scripts/*']
file 'version'

file 'archbox.json' => 'scripts/provision.sh'

file 'boxes/arch-base.box' => ['boxes', 'archbox.json', 'version'] do
  sh 'rm -f boxes/arch-base.box'
  sh 'vagrant box remove arch-base-local'
  sh 'packer build archbox.json'
  sh 'vagrant box add arch-base-local boxes/arch-base.box'
end

rule %r{boxes/arch-.*\.box} => 'boxes/arch-base.box' do |t|
  t.name =~ /arch-([^\.]*).box/
  box = $1
  sh %Q(
    vagrant destroy -f arch-#{box}
    vagrant --parallel up arch-#{box}
    vagrant package --base arch-#{box} --output boxes/arch-#{box}.box
    vagrant box add arch-#{box}-local boxes/arch-#{box}.box
  )
end

task :ssh, [:box] do |_, args|
  system "vagrant ssh arch-#{args[:box]}"
end


namespace :upload do
  task :chef => 'boxes/arch-chef.box' do
    Rake::Task[:"upload:go"].invoke("chef")
  end

  task :puppet => 'boxes/arch-puppet.box' do
    Rake::Task[:"upload:go"].invoke("puppet")
  end

  task :base => 'boxes/arch-base.box' do
    Rake::Task[:"upload:go"].invoke("base")
  end
  task :go, [:box] do |_, args|
    s3 = AWS::S3.new
    bucket = s3.buckets['jgf-vagrantboxes']

    version = File.read('version')

    box = args[:box]

    obj = bucket.objects["archbox/v#{version}/arch-#{box}.box"]
    obj.write(file: "boxes/arch-#{box}.box")
  end
end

desc 'upload the given box to S3'
task :upload, [:box] do |_, args|
  # This whole setup is so that running `rake upload[chef] will build and upload
  # the chef box in one go.
  Rake::Task[:"upload:#{args[:box]}"].invoke
end

file 'boxes/arch-chef.box' => ['scripts/chef.sh', 'boxes/arch-base.box']
file 'boxes/arch-puppet.box' => ['scripts/puppet.sh', 'boxes/arch-base.box']

task default: ['boxes/arch-chef.box', 'boxes/arch-puppet.box']

multitask :clean do
  sh %q(
    vagrant destroy -f arch-base arch-chef arch-puppet
  )
end

multitask :boxclean => :clean do
  sh %q(
    vagrant box remove arch-base-local
    vagrant box remove arch-chef-local
    vagrant box remove arch-puppet-local
  )
end

multitask :distclean => [:boxclean, :clean] do
  sh %q(
    rm boxes/arch-*.box
  )
end
