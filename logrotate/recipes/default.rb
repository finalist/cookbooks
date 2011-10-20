package "logrotate"

template "/etc/logrotate.d/#{node[:application]}.conf" do
  source 'rotate.conf.erb'
  owner 'root'
  group 'root'
  mode 0644
end
