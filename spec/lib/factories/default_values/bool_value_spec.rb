require 'spec_helper'

RSpec.describe RubyHome::BoolDefaultValue do
  describe '#default' do
    it 'returns false' do
      template = double
      handler = RubyHome::BoolDefaultValue.new(template)
      expect(handler.default).to eql(false)
    end
  end
end
