require 'spec_helper'
require_relative '../../../../../lib/rubyhome/hap/models/characteristics/firmware_revision'

RSpec.describe Rubyhome::Characteristic::FirmwareRevision, type: :model do
  let(:service) { Rubyhome::Service::AccessoryInformation.create }
  subject { described_class.new(value: '100.1.1', service: service) }

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
