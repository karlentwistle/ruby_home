require 'spec_helper'
require_relative '../../../../../lib/rubyhome/hap/models/services/accessory_information'

RSpec.describe Rubyhome::Service::AccessoryInformation, type: :model do
  let(:accessory) { Rubyhome::Accessory.create }
  subject { described_class.new(accessory: accessory) }

  describe 'Validations' do
    it 'is valid with valid attributes' do
      expect(subject).to be_valid
    end
  end
end
