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
    rm templates/*
  )
end

namespace :ssh do
  # these all assume the machine is up.

  task :base => :"up:base" do |_, args|
    Rake::Task[:"ssh:go"].invoke("base")
  end

  task :chef => :"up:chef" do |_, args|
    Rake::Task[:"ssh:go"].invoke("chef")
  end

  task :puppet => :"up:puppet" do |_, args|
    Rake::Task[:"ssh:go"].invoke("puppet")
  end

  task :go, [:box] do |_, args|
    sh "vagrant ssh arch-#{args[:box]}"
  end
end

desc 'ssh into the given box'
task :ssh, [:box] do |_, args|
  Rake::Task[:"ssh:#{args[:box]}"].invoke("puppet")
end

namespace :up do
  # these all assume the machine is up.

  task :base => 'boxes/arch-base.box' do |_, args|
    Rake::Task[:"up:go"].invoke("base")
  end

  task :chef => 'boxes/arch-chef.box' do |_, args|
    Rake::Task[:"up:go"].invoke("chef")
  end

  task :puppet => 'boxes/arch-puppet.box' do |_, args|
    Rake::Task[:"up:go"].invoke("puppet")
  end

  task :go, [:box] do |_, args|
    sh "vagrant up arch-#{args[:box]}"
  end
end

desc 'bring the give machine up'
task :up, [:box] do |_, args|
  Rake::Task[:"up:#{args[:box]}"].invoke("puppet")
end
