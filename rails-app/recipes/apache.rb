include_recipe 'passenger_apache2'
include_recipe 'passenger_apache2::mod_rails'

apache_module "expires"
apache_module "passenger"
apache_site "000-default" do
  enable false
end

web_app app do
  docroot "#{dir}/current/public"
  rails_env config[:environment]
  server_name "#{url_name}.#{node[:domain]}"
  server_aliases [ "#{url_name}", node[:hostname] ]
end
