require 'spec_helper'

RSpec.describe RubyHome::CharacteristicFactory do
  let(:accessory) { RubyHome::Accessory.new }
  let(:service) do
    RubyHome::Service.new(
      accessory: accessory,
      name: :air_purifier,
      description: "Air Purifier",
      uuid: "000000BB-0000-1000-8000-0026BB765291"
    )
  end

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

    it 'persists the characteristic within identifier cache' do
      characteristic = RubyHome::CharacteristicFactory.create(:position_state, service: service)

      expect(RubyHome::IdentifierCache.all).to include(
        an_object_having_attributes(
          accessory_id: 1,
          instance_id: 1,
          uuid: '00000072-0000-1000-8000-0026BB765291'
        )
      )
    end

    it "assigns the same instance_id to characteristic within an accessory" do
      RubyHome::IdentifierCache.create(
        accessory_id: 1,
        instance_id: 99,
        service_uuid: '000000BB-0000-1000-8000-0026BB765291',
        uuid: '000000A7-0000-1000-8000-0026BB765291',
        subtype: 'default'
      )

      characteristic = RubyHome::CharacteristicFactory.create(:lock_physical_controls, service: service)

      expect(characteristic.instance_id).to eql(99)
    end
  end
end
