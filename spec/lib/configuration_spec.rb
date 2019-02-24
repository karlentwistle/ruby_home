require 'spec_helper'

RSpec.describe RubyHome::Configuration do
  let(:accessory_info) { RubyHome::AccessoryInfo.instance }
  subject(:configuration) { described_class.new }

  describe '#discovery_name' do
    it 'defaults to RubyHome' do
      expect(configuration.discovery_name).to eql('RubyHome')
    end

    it 'allows configuration of discovery_name' do
      configuration.discovery_name = 'Custom Model Name'
      expect(configuration.discovery_name).to eql('Custom Model Name')
    end
  end

  describe '#model_name' do
    it 'defaults to RubyHome' do
      expect(configuration.model_name).to eql('RubyHome')
    end

    it 'allows configuration of model_name' do
      configuration.model_name = 'Device1,1'
      expect(configuration.model_name).to eql('Device1,1')
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

  describe "#bind" do
    it 'defaults to 0.0.0.0' do
      expect(configuration.bind).to eql('0.0.0.0')
    end

    it 'allows configuration of bind' do
      configuration.bind = '127.0.0.1'
      expect(configuration.bind).to eql('127.0.0.1')
    end
  end
end
