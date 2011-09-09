config = node[:app]
app = config[:name]
dir = config[:dir]
user_name = config[:user]
group_name = config[:group]

gem_package "ruby-shadow"
gem_package "bundler"

user user_name do
  comment  "This user manages the application"
  shell    "/bin/bash"
  password config[:password]
  home     "/home/#{user_name}"
end

directory "/home/#{user_name}" do
  owner user_name
  group group_name
  mode  "0755"
end

directory "#{dir}/shared" do
  owner user_name
  group group_name
  mode  "0755"
end

# we need a normal hash to convert to yaml
db_yaml = {}
config[:database].each_key do |key|
  db_yaml[key.to_s] = config[:database][key]
end

file "#{dir}/shared/database.yml" do
  owner user_name
  group group_name
  content({ "#{config[:environment]}" => db_yaml }.to_yaml)
end
