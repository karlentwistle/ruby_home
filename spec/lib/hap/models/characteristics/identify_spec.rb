require 'spec_helper'
require_relative '../../../../../lib/rubyhome/hap/models/characteristics/identify'

RSpec.describe Rubyhome::Characteristic::Identify, type: :model do
  let(:service) { Rubyhome::Service::AccessoryInformation.create }
  subject { described_class.new(service: service) }

  describe 'Validations' do
    it 'is valid with valid attributes' do
      expect(subject).to be_valid
    end
  end
end
