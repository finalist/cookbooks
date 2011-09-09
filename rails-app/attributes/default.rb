default[:app][:webserver] = false

default[:app][:name]        = "rails"
default[:app][:home_dir]    = "/home/#{app[:name]}"
default[:app][:dir]         = app[:home_dir]
default[:app][:password]    = "$1$zXpHrCSH$vJuDb5aMUL25efBb7BIaK/"
default[:app][:environment] = "production"

default[:app][:database] = Mash.new
default[:app][:database][:adapter]  = "mysql2"
default[:app][:database][:database] = "#{app[:name]}_#{app[:environment]}"
default[:app][:database][:pool]     = 5
default[:app][:database][:timeout]  = 5000
default[:app][:database][:host]     = "localhost"
default[:app][:database][:username] = app[:name]
default[:app][:database][:password] = "changeme!"
