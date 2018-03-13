require 'spec_helper'

RSpec.describe Rubyhome::ThermostatFactory do
  describe '.new' do
    it 'requires name' do
      expect(Rubyhome::ThermostatFactory.new).to be_truthy
    end
  end
end
