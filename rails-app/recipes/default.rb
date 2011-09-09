config = node[:app]
app = config[:name]
dir = config[:dir]

gem_package "ruby-shadow"
gem_package "bundler"

user app do
  comment "This user manages the application"
  shell "/bin/bash"
  password config[:password]
  home dir
end

directory dir do
  owner app
  group app
  mode "0755"
end

directory "#{dir}/shared" do
  owner app
  group app
  mode "0755"
end

# we need a normal hash to convert to yaml
db_yaml = {}
config[:database].each_key do |key|
  db_yaml[key.to_s] = config[:database][key]
end

file "#{dir}/shared/database.yml" do
  owner app
  group app
  content({ "#{config[:environment]}" => db_yaml }.to_yaml)
end
