require 'spec_helper'
require_relative '../../../../../lib/rubyhome/hap/models/characteristics/firmware_revision'

RSpec.describe Rubyhome::Service::AccessoryInformation, type: :model do
  subject { described_class.new }

  describe 'Validations' do
    it 'is valid with valid attributes' do
      expect(subject).to be_valid
    end
  end
end
