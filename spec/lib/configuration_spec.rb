require 'spec_helper'

RSpec.describe RubyHome::Configuration do
  let(:accessory_info) { RubyHome::AccessoryInfo.instance }
  subject(:configuration) { described_class.new }

  it 'allows configuration of model_name' do
    configuration.model_name = 'Custom Model Name'
    expect(configuration.model_name).to eql('Custom Model Name')
  end

  it 'sets model_name within accessory info' do
    configuration.model_name = 'Custom Model Name'
    expect(accessory_info.model_name).to eql('Custom Model Name')
  end

  it 'allows configuration of password' do
    configuration.password = '031-45-154'
    expect(configuration.password).to eql('031-45-154')
  end

  it 'sets password within accessory info' do
    configuration.password = '031-45-154'
    expect(accessory_info.password).to eql('031-45-154')
  end
end
