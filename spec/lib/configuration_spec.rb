require 'spec_helper'

RSpec.describe RubyHome::Configuration do
  let(:accessory_info) { RubyHome::AccessoryInfo.instance }
  subject(:configuration) { described_class.new }

  describe '#model_name' do
    it 'allows configuration of model_name' do
      configuration.model_name = 'Custom Model Name'
      expect(configuration.model_name).to eql('Custom Model Name')
    end

    it 'sets model_name within accessory info' do
      configuration.model_name = 'Custom Model Name'
      expect(accessory_info.model_name).to eql('Custom Model Name')
    end
  end

  describe "#password" do
    it 'allows configuration of password' do
      configuration.password = '031-45-154'
      expect(configuration.password).to eql('031-45-154')
    end

    it 'sets password within accessory info' do
      configuration.password = '031-45-154'
      expect(accessory_info.password).to eql('031-45-154')
    end
  end

  describe '#port' do
    it 'defaults to 4567' do
      expect(configuration.port).to eql(4567)
    end

    it 'allows configuration of port' do
      configuration.port = 8080
      expect(configuration.port).to eql(8080)
    end
  end
end
