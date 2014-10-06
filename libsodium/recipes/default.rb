require_recipe 'build-essential'

version = '0.4.5'
libsodium_url = "https://download.libsodium.org/libsodium/releases/old/libsodium-#{version}.tar.gz"
libsodium_tar = "libsodium-#{version}.tar.gz"
libsodium_dir = "libsodium-#{version}"
libsodium_lib = "/usr/local/lib/libsodium.so"

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
  not_if do
    File.exists?(libsodium_lib) && File.readlink(libsodium_lib).include?("4.5")
  end
end
