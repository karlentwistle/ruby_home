require 'spec_helper'

RSpec.describe Rubyhome::Service::AccessoryInformation, type: :model do
  let(:accessory) { Rubyhome::Accessory.create }
  subject { described_class.new(accessory: accessory) }

  describe 'Validations' do
    it 'is valid with valid attributes' do
      expect(subject).to be_valid
    end
  end
end
