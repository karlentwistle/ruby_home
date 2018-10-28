require 'spec_helper'

RSpec.describe RubyHome::CharacteristicFactory do
  let(:accessory) { double(next_available_instance_id: 1) }
  let(:service) { double(characteristics: [], accessory: accessory) }

  describe '.create' do
    it 'creates a characteristic with the specified name' do
      characteristic = RubyHome::CharacteristicFactory.create(:on, service: service)

      expect(characteristic.name).to eql(:on)
    end

    it "assigns the characteristic to the service" do
      characteristic = RubyHome::CharacteristicFactory.create(:on, service: service)

      expect(service.characteristics).to include(characteristic)
    end

    it 'assigns the correct description' do
      characteristic = RubyHome::CharacteristicFactory.create(:optical_zoom, service: service)

      expect(characteristic.description).to eql('Optical Zoom')
    end

    it 'assigns the correct uuid' do
      characteristic = RubyHome::CharacteristicFactory.create(:position_state, service: service)

      expect(characteristic.uuid).to eql('00000072-0000-1000-8000-0026BB765291')
    end
  end
end
