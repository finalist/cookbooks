maintainer        "Finalist"
maintainer_email  "arie@finalist.nl"
license           "MIT"
description       "Installs libsodium"
long_description  IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version           "0.0.1"


depends "build-essential"

%w{ ubuntu debian }.each do |os|
  supports os
end