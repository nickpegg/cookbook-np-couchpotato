#
# Cookbook Name:: np-couchpotato
# Spec:: default
#
# Copyright (c) 2016 Nick Pegg, All Rights Reserved.

require 'spec_helper'

describe 'np-couchpotato::default' do
  before :all do
    @chef_run = memoized_runner(described_recipe)
  end

  subject { @chef_run }

  it { is_expected.to include_recipe('np-couchpotato::install') }
  it { is_expected.to include_recipe('np-couchpotato::configure') }
end
