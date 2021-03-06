#
# Cookbook Name:: neo4j-server
# Recipe:: default
# Copyright 2012, Michael S. Klishin <michaelklishin@me.com>
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.

include_recipe "java"

#
# User accounts
#

user node.neo4j.server.user do
  comment "Neo4J Server user"
  home    node.neo4j.server.installation_dir
  shell   "/bin/bash"
  action  :create
end

group node.neo4j.server.user do
  (m = []) << node.neo4j.server.user
  members m
  action :create
end

# 1. Download the tarball to /tmp
require "tmpdir"

td          = Dir.tmpdir
tmp         = File.join(td, "neo4j-#{node.neo4j.server.version}.tar.gz")
tarball_dir = File.join(td, "neo4j-#{node.neo4j.server.version}")

remote_file(tmp) do
  source node.neo4j.server.tarball.url

  not_if "which neo4j"
end

# 2. Extract it
# 3. Copy to /usr/local/neo4j-server, update permissions
bash "extract #{tmp}, move it to #{node.neo4j.server.installation_dir}" do
  user "root"
  cwd  "/tmp"

  code <<-EOS
    rm -rf #{node.neo4j.server.installation_dir}
    tar xfz #{tmp}
    mv --force #{tarball_dir} #{node.neo4j.server.installation_dir}
  EOS

  creates "#{node.neo4j.server.installation_dir}/bin/neo4j"
end

[node.neo4j.server.conf_dir, node.neo4j.server.data_dir, File.join(node.neo4j.server.data_dir, "log")].each do |dir|
  directory dir do
    owner     node.neo4j.server.user
    group     node.neo4j.server.user
    recursive true
    action    :create
  end
end

[node.neo4j.server.lib_dir,
 node.neo4j.server.data_dir,
 File.join(node.neo4j.server.installation_dir, "data"),
 File.join(node.neo4j.server.installation_dir, "system"),
 node.neo4j.server.installation_dir].each do |dir|
  # Chef sets permissions only to leaf nodes, so we have to use a Bash script. MK.
  bash "chown -R #{node.neo4j.server.user}:#{node.neo4j.server.user} #{dir}" do
    user "root"

    code "chown -R #{node.neo4j.server.user}:#{node.neo4j.server.user} #{dir}"
  end
end

# 4. Symlink
%w(neo4j neo4j-shell).each do |f|
  link "/usr/local/bin/#{f}" do
    owner node.neo4j.server.user
    group node.neo4j.server.user
    to    "#{node.neo4j.server.installation_dir}/bin/#{f}"

    not_if "test -L /usr/local/bin/#{f}"
  end
end

# 5. Install config files
template "#{node.neo4j.server.conf_dir}/neo4j-server.properties" do
  source "neo4j-server.properties.erb"
  owner node.neo4j.server.user
  mode  0644
end

template "#{node.neo4j.server.conf_dir}/neo4j-wrapper.conf" do
  source "neo4j-wrapper.conf.erb"
  owner node.neo4j.server.user
  mode  0644
end

# 6. Know Your Limits
template "/etc/security/limits.d/#{node.neo4j.server.user}.conf" do
  source "neo4j-limits.conf.erb"
  owner node.neo4j.server.user
  mode  0644
end

ruby_block "make sure pam_limits.so is required" do
  block do
    fe = Chef::Util::FileEdit.new("/etc/pam.d/su")
    fe.search_file_replace_line(/# session    required   pam_limits.so/, "session    required   pam_limits.so")
    fe.write_file
  end
end

# 6. init.d Service
template "/etc/init.d/neo4j" do
  source "neo4j.init.erb"
  owner 'root'
  mode  0755
end

service "neo4j" do
  supports :start => true, :stop => true, :restart => true
  action [:enable, :start]
end
