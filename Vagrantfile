#!/usr/bin/env ruby
Vagrant::Config.run do |config|
  config.vm.provision :chef_solo, :cookbooks_path => ".", :run_list => "recipe[#{ENV["RECIPE"]}]"
  config.vm.box = 'lucid32'
end
