require 'spec_helper'
require_relative '../../../../../lib/rubyhome/hap/models/characteristics/model'

RSpec.describe Rubyhome::Characteristic::Model, type: :model do
  subject { described_class.new(value: 'A1234') }

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
