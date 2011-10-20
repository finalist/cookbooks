package "logrotate"

service "logrotate" do
  supports :restart => false, :reload => true, :status => true
  action [ :enable, :start ]
end

template "/etc/logrotate.d/#{application_directory}.conf" do
  notifies :reload, resources( :service => "logrotate" )
end

template "/etc/logrotate.d/#{application_directory}.conf" do
  source 'rotate.conf'
  owner 'root'
  group 'root'
  mode 0644
end
