require 'spec_helper'
describe 'cacti' do
  context 'with default values for all parameters' do
    it { should contain_class('cacti') }
  end
end
