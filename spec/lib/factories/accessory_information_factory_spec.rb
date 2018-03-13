require 'spec_helper'

RSpec.describe Rubyhome::AccessoryInformationFactory do
  describe '.new' do
    it 'requires name' do
      expect(Rubyhome::AccessoryInformationFactory.new).to be_truthy
    end
  end
end
