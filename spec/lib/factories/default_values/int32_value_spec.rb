require 'spec_helper'

RSpec.describe RubyHome::Int32DefaultValue do
  describe '#default' do
    it 'returns minimum value from template constraints' do
      template = double(constraints: { 'MinimumValue' => 10 } )
      handler = RubyHome::Int32DefaultValue.new(template)
      expect(handler.default).to eql(10)
    end
  end
end
