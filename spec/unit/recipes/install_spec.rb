#
# Cookbook Name:: np-couchpotato
# Spec:: default
#
# Copyright (c) 2016 Nick Pegg, All Rights Reserved.

require 'spec_helper'

describe 'np-couchpotato::install' do
  before :all do
    @chef_run = memoized_runner(described_recipe)
  end

  subject { @chef_run }

  %w[apt build-essential].each do |recipe|
    it { is_expected.to include_recipe recipe }
  end

  it { is_expected.to install_package 'git' }
  it { is_expected.to install_package %w[libffi-dev libssl-dev libxml2-dev] }

  %w[lxml pyopenssl].each do |mod|
    it { is_expected.to install_python_package mod }
    it { is_expected.to upgrade_python_package mod }
  end

  it do
    is_expected.to create_poise_service_user('couchpotato').with(
      group: 'usenet',
      home: '/opt/couchpotato'
    )
  end

  it do
    is_expected.to create_directory('/opt/couchpotato').with(
      owner: 'couchpotato',
      group: 'usenet'
    )
  end

  it { is_expected.to create_remote_file(::File.join(Chef::Config[:cache_path], 'CouchPotatoServer-3.0.1.tar.gz')) }

  it do
    is_expected.to enable_poise_service('couchpotato').with(
      user: 'couchpotato',
      directory: '/opt/couchpotato',
      command: '/opt/couchpotato/CouchPotato.py'
    )
  end
end
