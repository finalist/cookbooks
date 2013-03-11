name             "libyaml"
maintainer       "Cassiano Leal"
maintainer_email "cl@cassianoleal.com"
license          "Apache 2.0"
description      "Installs/Configures libyaml"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "0.1.0"
recipe           "libyaml", "Installs libyaml from source"

%w{ debian ubuntu }.each do |os|
  supports os
end

%w{ build-essential apt }.each do |cb|
  depends cb
end
