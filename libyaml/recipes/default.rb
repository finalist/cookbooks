#
# Cookbook Name:: libyaml
# Recipe:: default
#
# Copyright (C) 2012 Cassiano Leal
# 
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

include_recipe 'build-essential'

version = node['libyaml']['version']

remote_file "#{Chef::Config[:file_cache_path]}/yaml-#{version}.tar.gz" do
  source "#{node['libyaml']['url']}/yaml-#{version}.tar.gz"
  checksum node['libyaml']['checksum']
  mode 0644
end

lib_name = value_for_platform("default" => "libyaml.so")

bash "build libyaml from source" do
  cwd Chef::Config[:file_cache_path]
  code <<-EOH
  tar zxvf yaml-#{version}.tar.gz
  (cd yaml-#{version} && ./configure #{node['libyaml']['configure_options'].join(" ")})
  (cd yaml-#{version} && make && make install)
  EOH
  not_if { ::File.exists?("/usr/local/lib/#{lib_name}") }
end
