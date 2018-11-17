require 'spec_helper'

RSpec.describe RubyHome::Uint8Value do
  describe '#default' do
    it 'returns first default value from valid values' do
      template = double(constraints: { 'ValidValues' => { '0' => 'Inactive' } } )
      handler = RubyHome::Uint8Value.new(template)
      expect(handler.default).to eql(0)
    end
  end
end
