require 'spec_helper'
describe 'puppetmaster_webhook' do
  context 'with default values for all parameters' do
    it { should contain_class('puppetmaster_webhook') }
  end
end
