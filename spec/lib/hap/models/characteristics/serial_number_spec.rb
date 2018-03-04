require 'spec_helper'
require_relative '../../../../../lib/rubyhome/hap/models/characteristics/serial_number'

RSpec.describe Rubyhome::Characteristic::SerialNumber, type: :model do
  subject { described_class.new(value: '1A2B3C4D5E6F') }

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
