require 'spec_helper'

RSpec.describe Rubyhome::FanFactory do
  describe '.new' do
    it 'requires name' do
      expect(Rubyhome::FanBuilder.new).to be_truthy
    end
  end
end
