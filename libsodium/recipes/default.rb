require_recipe 'build-essential'

version = '0.3'
libsodium_url  = "http://marvin.ariekanarie.nl/libsodium-#{version}.tar.gz"
libsodium_tar  = "libsodium-#{version}.tar.gz"
libsodium_dir  = "libsodium-#{version}"

package "wget" do
  action :install
end

remote_file "/tmp/#{libsodium_tar}" do
  source "#{libsodium_url}"
  mode 0644
  action :create_if_missing
end

execute "tar -xf #{libsodium_tar}" do
  cwd "/tmp"
  creates libsodium_dir
end

execute "compile libsodium" do
  command "./configure && make && make check && make install"
  user "root"
  cwd "/tmp/#{libsodium_dir}"
  creates "/usr/local/lib/libsodium.so"
end
