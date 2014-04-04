rule %r{boxes/arch-.*\.box} => 'boxes/arch-base.box' do |t|
  t.name =~ /arch-([^\.]*).box/
  box = $1
  sh %Q(vagrant destroy -f arch-#{box})
  sh %Q(vagrant up arch-#{box})
  sh %Q{rm -f boxes/arch-#{box}.box}
  sh %Q(vagrant package arch-#{box} --output boxes/arch-#{box}.box)
  sh %Q(vagrant box add arch-#{box}-local boxes/arch-#{box}.box)
end
