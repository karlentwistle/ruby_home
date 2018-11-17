require 'spec_helper'

RSpec.describe RubyHome::StringValue do
  describe '#default' do
    it 'returns 1.0 for Firmware Revision template' do
      template = double(name: :firmware_revision)
      handler = RubyHome::StringValue.new(template)
      expect(handler.default).to eql('1.0')
    end

    it 'returns 1.0 for Hardware Revision' do
      template = double(name: :hardware_revision)
      handler = RubyHome::StringValue.new(template)
      expect(handler.default).to eql('1.0')
    end

    it 'returns 1.0 for Version' do
      template = double(name: :version)
      handler = RubyHome::StringValue.new(template)
      expect(handler.default).to eql('1.0')
    end

    it 'returns Default-Manufacturer for Manufacturer' do
      template = double(name: :manufacturer)
      handler = RubyHome::StringValue.new(template)
      expect(handler.default).to eql('Default-Manufacturer')
    end

    it 'returns Default-Model for Model' do
      template = double(name: :model)
      handler = RubyHome::StringValue.new(template)
      expect(handler.default).to eql('Default-Model')
    end

    it 'returns RubyHome for Name' do
      template = double(name: :name)
      handler = RubyHome::StringValue.new(template)
      expect(handler.default).to eql('RubyHome')
    end

    it 'returns Default-SerialNumber for Serial Number' do
      template = double(name: :serial_number)
      handler = RubyHome::StringValue.new(template)
      expect(handler.default).to eql('Default-SerialNumber')
    end

    it 'returns nil for unknown template' do
      template = double(name: :foo)
      handler = RubyHome::StringValue.new(template)
      expect(handler.default).to be_nil
    end
  end
end
