require 'spec_helper'
describe 'puppetmaster_webhook::service' do
  on_supported_os.each do |os, facts|
    context "on #{os} with default values for all parameters" do
      let(:facts) do
        facts
      end

      it { is_expected.to contain_service('puppetmaster_webhook').with_ensure('running') }
      it { is_expected.to contain_service('puppetmaster_webhook').with_hasstatus(true) }
      it { is_expected.to contain_service('puppetmaster_webhook').with_enable(true) }
      it { is_expected.to contain_service('puppetmaster_webhook').with_hasrestart(true) }
    end
  end
end
