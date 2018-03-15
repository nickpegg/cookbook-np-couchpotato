#
# Cookbook Name:: np-couchpotato
# Recipe:: install
#
# Copyright (c) 2016 Nick Pegg, All Rights Reserved.

# Install CouchPotatoServer from source

include_recipe 'apt'

package 'git'

include_recipe 'python'
include_recipe 'build-essential'

# Required Python modules
package %w(libffi-dev libssl-dev libxml2-dev)

%w(lxml pyopenssl).each do |mod|
  python_pip mod do
    action [:install, :upgrade]
  end
end

poise_service_user node[:np_couchpotato][:system_user] do
  group node[:np_couchpotato][:system_group]
  home node[:np_couchpotato][:install_path]
end

directory node[:np_couchpotato][:install_path] do
  owner node[:np_couchpotato][:system_user]
  group node[:np_couchpotato][:system_group]
  mode 0755
end

directory ::File.join(Chef::Config[:cache_path])

version = node[:np_couchpotato][:version]
tarball_path = ::File.join(Chef::Config[:cache_path], "CouchPotatoServer-#{version}.tar.gz")
remote_file tarball_path do
  source "https://codeload.github.com/CouchPotato/CouchPotatoServer/tar.gz/build/#{version}"
  checksum node[:np_couchpotato][:checksum]

  notifies :run, 'execute[extract couchpotato]', :immediately
end

execute 'extract couchpotato' do
  action :nothing
  command "tar -xzf '#{tarball_path}' --strip-components 1"
  cwd node[:np_couchpotato][:install_path]

  # Only restart if it's running to avoid a race condition on first start
  notifies :restart, 'poise_service[couchpotato]', :delayed if `ps aux`.include? 'couchpotato'
end

poise_service 'couchpotato' do
  action :enable

  user node[:np_couchpotato][:system_user]
  directory node[:np_couchpotato][:install_path]
  command ::File.join(node[:np_couchpotato][:install_path], 'CouchPotato.py')
end
