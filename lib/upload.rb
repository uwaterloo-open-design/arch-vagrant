namespace :upload do
  task :chef => 'boxes/arch-chef.box' do
    Rake::Task[:'upload:go'].invoke('chef')
  end

  task :puppet => 'boxes/arch-puppet.box' do
    Rake::Task[:'upload:go'].invoke('puppet')
  end

  task :base => 'boxes/arch-base.box' do
    Rake::Task[:'upload:go'].invoke('base')
  end

  task :go, [:box] do |_, args|
    puts "uploading #{args[:box]}"

    s3 = AWS::S3.new
    bucket = s3.buckets['jgf-vagrantboxes']

    version = CONFIG['version']
    date = CONFIG['iso']['date']

    box = args[:box]

    obj = bucket.objects["archbox/v#{version}-#{date}/arch-#{box}.box"]
    obj.write(file: "boxes/arch-#{box}.box")

    puts "finished uploading #{args[:box]}"
  end

  task :all => ['upload:base', 'upload:chef', 'upload:puppet']
end

desc 'upload the given box to S3'
task :upload, [:box] do |_, args|
  # This whole setup is so that running `rake upload[chef] will build and upload
  # the chef box in one go.
  Rake::Task[:"upload:#{args[:box]}"].invoke
end
