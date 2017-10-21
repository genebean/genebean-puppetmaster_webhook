require 'spec_helper'
describe 'puppetmaster_webhook::install' do
  on_supported_os.each do |os, facts|
    context "on #{os} with default values for all parameters" do
      let(:facts) do
        facts
      end

      it { is_expected.to contain_package('bundler').with_provider('puppet_gem') }
    end
  end
end