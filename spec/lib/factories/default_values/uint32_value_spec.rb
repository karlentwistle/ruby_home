require 'spec_helper'

RSpec.describe RubyHome::Uint32DefaultValue do
  describe '#default' do
    it 'returns 0 for Lock Management Auto Security Timeout template' do
      template = double(name: :lock_management_auto_security_timeout)
      handler = RubyHome::Uint32DefaultValue.new(template)
      expect(handler.default).to eql(0)
    end

    it 'returns 50 for Color Temperature template' do
      template = double(name: :color_temperature)
      handler = RubyHome::Uint32DefaultValue.new(template)
      expect(handler.default).to eql(50)
    end

    it 'returns nil for any other template' do
      template = double(name: :foo)
      handler = RubyHome::Uint32DefaultValue.new(template)
      expect(handler.default).to be_nil
    end
  end
end
