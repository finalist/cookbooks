# Description

FreeTDS 0.91, required for connecting to MS SQLServer 2005 or 2008.

# Usage

You'll need this inside your Gemfile:

    gem 'activerecord-sqlserver-adapter'
    gem 'tiny_tds'

Example `database.yml`:

    production:
      adapter: sqlserver
      host: [host_or_ip]
      port: [port]
      database: [database]
      username: [username]
      password: [password]

# Note

Made by a Chef noob. Please use with caution.
