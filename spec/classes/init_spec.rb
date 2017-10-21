require 'spec_helper'
describe 'puppetmaster_webhook' do
  on_supported_os.each do |os, facts|
    context "on #{os} with default values for all parameters" do
      let(:facts) do
        facts
      end

      it { is_expected.to compile }
      it { is_expected.to contain_class('puppetmaster_webhook') }
    end
  end
end
