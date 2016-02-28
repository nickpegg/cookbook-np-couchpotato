require 'spec_helper'

describe 'np-couchpotato::install' do
  describe user 'couchpotato' do
    it { is_expected.to exist }
    it { is_expected.to belong_to_group 'usenet' }
    it { is_expected.to have_home_directory '/opt/couchpotato' }
  end

  describe group 'usenet' do
    it { is_expected.to exist }
  end

  describe file '/opt/couchpotato' do
    it { is_expected.to be_directory }
    it { is_expected.to be_owned_by 'couchpotato' }
    it { is_expected.to be_grouped_into 'usenet' }
  end

  describe service 'couchpotato' do
    it { is_expected.to be_enabled }
    it { is_expected.to be_running }
  end

  describe process 'python /opt/couchpotato/CouchPotato.py' do
    it { is_expected.to be_running }
    its(:user) { is_expected.to eq 'couchpotato' }
  end

  describe port 5050 do
    it { is_expected.to be_listening.with('tcp') }
  end
end
