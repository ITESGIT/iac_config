require 'spec_helper'
describe 'stig' do
  context 'with default values for all parameters' do
    it { should contain_class('stig') }
  end
end
