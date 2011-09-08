require_recipe 'build-essential'

freetds_url  = 'http://ibiblio.org/pub/Linux/ALPHA/freetds/stable/freetds-0.91.tar.gz'
freetds_tar  = 'freetds-0.91.tar.gz'
freetds_dir  = 'freetds-0.91'
freetds_conf = '/usr/local/etc/freetds.conf'

package "wget" do
  action :install
end

remote_file "/tmp/#{freetds_tar}" do
  source "#{freetds_url}"
  mode 0644
  action :create_if_missing
end

execute "tar -xf #{freetds_tar}" do
  cwd "/tmp"
  user "root"
end

execute "compile freetds" do
  command "./configure && make && make install"
  user "root"
  cwd "/tmp/#{freetds_dir}"
end

template freetds_conf do
  source "freetds.conf"
  owner "root"
  group "root"
end

execute "ldconfig" do
  command "ldconfig"
  user "root"
end
