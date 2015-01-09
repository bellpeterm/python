#
# Author:: Seth Chisamore <schisamo@opscode.com>
# Cookbook Name:: python
# Recipe:: pip
#
# Copyright 2011, Opscode, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

# Where does pip get installed?
# platform/method: path (proof)
# redhat/package: /usr/bin/pip (sha a8a3a3)
# omnibus/source: /opt/local/bin/pip (sha 29ce9874)

include_recipe 'chef-sugar::default'
require 'chef/sugar/core_extensions'

if node['python']['install_method'] == 'source'
  pip_binary = "#{node['python']['prefix_dir']}/bin/pip"
elsif platform_family?("rhel", "fedora")
  pip_binary = "/usr/bin/pip"
elsif platform_family?("smartos")
  pip_binary = "/opt/local/bin/pip"
else
  pip_binary = "/usr/local/bin/pip"
end

remote_file "#{Chef::Config[:file_cache_path]}/get-pip.py" do
  source 'https://bootstrap.pypa.io/get-pip.py'
  mode "0644"
  action :create_if_missing
  notifies :run, 'execute[install-pip]', :immediately
end

execute "install-pip" do
  cwd Chef::Config[:file_cache_path]
  command <<-EOF
  #{node['python']['binary']} get-pip.py
  EOF
  action :nothing
end

remote_file "#{Chef::Config[:file_cache_path]}/ez_setup.py" do
  source 'https://bootstrap.pypa.io/ez_setup.py'
  mode "0644"
  action :create_if_missing
  notifies :run, 'execute[install-setuptools]', :immediately
end

execute "install-setuptools" do
  cwd Chef::Config[:file_cache_path]
  command <<-EOF
  #{node['python']['binary']} ez_setup.py
  EOF
  action :nothing
end

python_pip 'pip' do
  action :upgrade
  version node['python']['pip_version']
end

python_pip 'setuptools' do
  action :upgrade
  version node['python']['setuptools_version']
end

python_pip 'yolk' do
  action :upgrade
  version node['python']['yolk_version']
end