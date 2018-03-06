require 'spec_helper'

RSpec.describe Rubyhome::Characteristic::Identify, type: :model do
  let(:accessory) { Rubyhome::Accessory.create }
  let(:service) { Rubyhome::Service::AccessoryInformation.create(accessory: accessory) }
  subject { described_class.new(value: '100.1.1', service: service) }

  describe 'Validations' do
    it 'is valid with valid attributes' do
      expect(subject).to be_valid
    end
  end
end
