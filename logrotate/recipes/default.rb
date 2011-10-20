package "logrotate"

template "/etc/logrotate.d/#{node[:application_directory]}.conf" do
  source 'rotate.conf'
  owner 'root'
  group 'root'
  mode 0644
end
