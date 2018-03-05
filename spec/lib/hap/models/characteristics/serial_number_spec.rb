require 'spec_helper'
require_relative '../../../../../lib/rubyhome/hap/models/characteristics/serial_number'

RSpec.describe Rubyhome::Characteristic::SerialNumber, type: :model do
  let(:service) { Rubyhome::Service::AccessoryInformation.create }
  subject { described_class.new(value: '1A2B3C4D5E6F', service: service) }

  describe 'Validations' do
    it 'is valid with valid attributes' do
      expect(subject).to be_valid
    end

    it 'is not valid without a value' do
      subject.value = nil
      expect(subject).to_not be_valid
    end
  end
end
