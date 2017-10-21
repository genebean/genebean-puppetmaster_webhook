require 'spec_helper'
describe 'puppetmaster_webhook::config' do
  on_supported_os.each do |os, facts|
    context "on #{os} with default values for all parameters" do
      let(:facts) do
        facts
      end

      it { is_expected.to contain_exec('create_webhook_homedir').with_command('mkdir -p /opt/webhook') }
      it { is_expected.to contain_exec('refresh_services').with_refreshonly(true) }
      it { is_expected.to contain_exec('run_bundler').with_command('/opt/puppetlabs/puppet/bin/bundle install --path vendor/bundle') }
      it { is_expected.to contain_exec('run_bundler').with_cwd('/opt/webhook') }

      it '/opt/webhook/config.ru is created with proper permissions' do
        is_expected.to contain_file('/opt/webhook/config.ru').with_ensure('file')
        is_expected.to contain_file('/opt/webhook/config.ru').with_owner('root')
        is_expected.to contain_file('/opt/webhook/config.ru').with_group('root')
        is_expected.to contain_file('/opt/webhook/config.ru').with_mode('0755')
        is_expected.to contain_file('/opt/webhook/config.ru').with_source('puppet:///modules/puppetmaster_webhook/config.ru')
      end

      it { is_expected.to contain_file('/opt/webhook/webhook_config.json').with_notify('Service[puppetmaster_webhook]') }
      it { is_expected.to contain_file('/opt/webhook/webhook_config.json').with_content(/\"bind\"\s+:\s\"0\.0\.0\.0\"/) }
      it { is_expected.to contain_file('/opt/webhook/Gemfile') }
      it { is_expected.to contain_file('/opt/webhook/log').with_ensure('directory') }
      it { is_expected.to contain_file('/opt/webhook/webhook.rb') }

      it 'the systemd unit file is created using variables from this module' do
        is_expected.to contain_file('/etc/systemd/system/puppetmaster_webhook.service').with_content(/User=root/)
        is_expected.to contain_file('/etc/systemd/system/puppetmaster_webhook.service').with_content(/WorkingDirectory=\/opt\/webhook/)
        is_expected.to contain_file('/etc/systemd/system/puppetmaster_webhook.service').with_content(/ExecStart=\/opt\/puppetlabs\/puppet\/bin\/bundle exec puma/)
      end
    end
  end
end
