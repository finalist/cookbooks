include_recipe 'passenger_apache2'
include_recipe 'passenger_apache2::mod_rails'

apache_module "expires"
apache_module "passenger"
apache_site "000-default" do
  enable false
end

web_app node[:app][:name] do
  docroot "#{node[:app][:dir]}/current/public"
  rails_env node[:app][:environment]
  server_name node[:app][:server_name]
  server_aliases [ node[:app][:server_alias] ]
end
