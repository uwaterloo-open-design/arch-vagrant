BOXES=[:chef,:puppet,:base,:'chef-local',:'puppet-local']

multitask :clean do
  BOXES.each do |box|
    sh %Q(vagrant destroy -f arch-#{box})
  end
end

multitask :boxclean => :clean do
  BOXES.each do |box|
    sh %Q(vagrant box remove arch-#{box})
  end
end

multitask :distclean => [:boxclean, :clean] do
  sh %q(
    rm boxes/arch-*.box
    rm templates/*
  )
end


namespace :ssh do
  # these all assume the machine is up.
  BOXES.each do |box|
    task box => :"up:#{box}" do |_, args|
      Rake::Task[:'ssh:go'].invoke(box)
    end
  end

  task :go, [:box] do |_, args|
    sh "vagrant ssh arch-#{args[:box]}"
  end
end

desc 'ssh into the given box'
task :ssh, [:box] do |_, args|
  Rake::Task[:"ssh:#{args[:box]}"].invoke('puppet')
end

namespace :up do
  # these all assume the machine is up.

  task :base => 'boxes/arch-base.box' do |_, args|
    Rake::Task[:'up:go'].invoke('base')
  end

  task :chef => 'boxes/arch-chef.box' do |_, args|
    Rake::Task[:'up:go'].invoke('chef')
  end

  task :puppet => 'boxes/arch-puppet.box' do |_, args|
    Rake::Task[:'up:go'].invoke('puppet')
  end

  task :'puppet-local' => 'boxes/arch-puppet.box' do |_, args|
    Rake::Task[:'up:go'].invoke('puppet-local')
  end

  task :'chef-local' => 'boxes/arch-chef.box' do |_, args|
    Rake::Task[:'up:go'].invoke('chef-local')
  end

  task :go, [:box] do |_, args|
    sh "vagrant up arch-#{args[:box]}"
  end
end

desc 'bring the give machine up'
task :up, [:box] do |_, args|
  Rake::Task[:"up:#{args[:box]}"].invoke("puppet")
end
