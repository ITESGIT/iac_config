require 'spec_helper'
describe 'user_config' do
  context 'with default values for all parameters' do
    it { should contain_class('user_config') }
  end
end
