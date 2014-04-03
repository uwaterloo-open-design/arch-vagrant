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

