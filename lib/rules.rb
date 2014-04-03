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
