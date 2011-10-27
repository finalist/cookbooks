package "dnsmasq"

service "dnsmasq" do
  supports :restart => true, :reload => true, :status => true
  action [ :enable, :start ]
end

template "/etc/dnsmasq.conf" do
  notifies :restart, resources(:service => "dnsmasq"), :immediately
end

template "/etc/resolv.conf" do
  source 'resolv.conf'
  owner 'root'
  group 'root'
  mode 0644
end
