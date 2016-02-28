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

application node[:np_couchpotato][:install_path] do
  owner node[:np_couchpotato][:system_user]
  group node[:np_couchpotato][:system_group]

  git do
    repo node[:np_couchpotato][:repo]
    revision node[:np_couchpotato][:ref]

    user node[:np_couchpotato][:system_user]
    group node[:np_couchpotato][:system_group]
  end
end

poise_service 'couchpotato' do
  action [:enable, :start]

  user node[:np_couchpotato][:system_user]
  directory node[:np_couchpotato][:install_path]
  command ::File.join(node[:np_couchpotato][:install_path], 'CouchPotato.py')
end
