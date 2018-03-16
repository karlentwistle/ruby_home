require 'spec_helper'

RSpec.describe Rubyhome::FanFactory do
  describe '#service' do
    it 'automatically generates a service' do
      fan = Rubyhome::FanFactory.new
      expect(fan.service).to be_a(Rubyhome::Service::Fan)
    end
  end

  describe '#accessory_information' do
    it 'automatically generates accessory information' do
      fan = Rubyhome::FanFactory.new
      expect(fan.accessory_information).to be_a(Rubyhome::AccessoryInformationFactory)
    end
  end

  describe '#on' do
    it 'returns the same instance' do
      fan = Rubyhome::FanFactory.new
      expect(fan.on.object_id).to eql(fan.on.object_id)
    end
  end
end
