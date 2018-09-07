require 'spec_helper'

RSpec.describe RubyHome::Uint8DefaultValue do
  describe '#default' do
    it 'returns first default value from valid values' do
      template = double(constraints: { 'ValidValues' => { '0' => 'Inactive' } } )
      handler = RubyHome::Uint8DefaultValue.new(template)
      expect(handler.default).to eql(0)
    end
  end
end
