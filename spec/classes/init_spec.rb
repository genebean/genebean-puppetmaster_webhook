require 'spec_helper'
describe 'puppetmaster_webhook' do
  on_supported_os.each do |os, facts|
    context "on #{os} with default values for all parameters" do
      let(:facts) do
        facts
      end

      it { is_expected.to compile }
      it { is_expected.to contain_class('puppetmaster_webhook') }
      it { is_expected.to contain_class('puppetmaster_webhook::install').that_comes_before('Class[puppetmaster_webhook::config]') }
      it { is_expected.to contain_class('puppetmaster_webhook::config').that_comes_before('Class[puppetmaster_webhook::service]') }
      it { is_expected.to contain_class('puppetmaster_webhook::service') }
    end
    context "on #{os} with puppet_agent_bin_dir set to 'bin'" do
      let(:facts) do
        facts
      end

      let(:params) do
        {
          'puppet_agent_bin_dir' => 'bin',
        }
      end

      it { is_expected.to compile.and_raise_error(/Variant\[Stdlib::Windowspath.*Stdlib::Unixpath/) }
    end
  end
end
