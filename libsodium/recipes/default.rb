require_recipe 'build-essential'

libsodium_url  = 'http://marvin.ariekanarie.nl/libsodium-0.2.tar.gz'
libsodium_tar  = 'libsodium-0.2.tar.gz'
libsodium_dir  = 'libsodium-0.2'

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
end
