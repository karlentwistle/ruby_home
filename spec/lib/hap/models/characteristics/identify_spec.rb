require 'spec_helper'
require_relative '../../../../../lib/rubyhome/hap/models/characteristics/identify'

RSpec.describe Rubyhome::Characteristic::Identify, type: :model do
  subject { described_class.new }

  describe 'Validations' do
    it 'is valid with valid attributes' do
      expect(subject).to be_valid
    end
  end
end
