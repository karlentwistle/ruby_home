require 'spec_helper'
require_relative '../../../../../lib/rubyhome/hap/models/characteristics/manufacturer'

RSpec.describe Rubyhome::Characteristic::Manufacturer, type: :model do
  let(:service) { Rubyhome::Service::AccessoryInformation.create }
  subject { described_class.new(value: 'Acme', service: service) }

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
