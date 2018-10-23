require 'spec_helper'

RSpec.describe RubyHome::IdentifierCache do
  subject(:instance) { RubyHome::IdentifierCache.instance }

  describe 'characteristics' do
    it 'always returns the same object' do
      instance_a = RubyHome::IdentifierCache.instance.characteristics.object_id
      instance_b = RubyHome::IdentifierCache.instance.characteristics.object_id

      expect(instance_a).to eql(instance_b)
    end
  end

  describe '#add_accessory' do
    it 'adds an accessory to accessories' do
      accessory = RubyHome::Accessory.new

      instance.add_accessory(accessory)

      expect(instance.accessories).to match_array([accessory])
    end

    it 'persists an accessory' do
      accessory = RubyHome::Accessory.new

      instance.add_accessory(accessory)
      instance.reload

      expect(instance.accessories).to match_array([accessory])
    end

    it 'doesnt persist a previously persisted accessory' do
      accessory = RubyHome::Accessory.new

      instance.add_accessory(accessory)
      instance.add_accessory(accessory)

      expect(instance.accessories).to match_array([accessory])
    end

    it 'automatically assigns incrementing ids to accessories' do
      accessory_1 = RubyHome::Accessory.new
      accessory_2 = RubyHome::Accessory.new

      instance.add_accessory(accessory_1)
      instance.add_accessory(accessory_2)

      expect(accessory_1.id).to eql(1)
      expect(accessory_2.id).to eql(2)
    end
  end

  describe '#add_service' do
    it 'adds a service to accessories services' do
      accessory = RubyHome::Accessory.new
      service = RubyHome::Service.new(
        accessory: accessory,
        name: 'fan',
        description: 'Accessory Information',
        uuid: '00000040-0000-1000-8000-0026BB765291'
      )

      instance.add_service(service)

      expect(instance.services).to match_array([service])
    end

    it 'persists a service' do
      accessory = RubyHome::Accessory.new
      service = RubyHome::Service.new(
        accessory: accessory,
        name: 'fan',
        description: 'Accessory Information',
        uuid: '00000040-0000-1000-8000-0026BB765291'
      )

      instance.add_service(service)
      instance.reload

      expect(instance.services).to match_array([service])
    end

    it 'doesnt persist a previously persisted service' do
      accessory = RubyHome::Accessory.new
      service = RubyHome::Service.new(
        accessory: accessory,
        name: 'fan',
        description: 'Accessory Information',
        uuid: '00000040-0000-1000-8000-0026BB765291'
      )

      instance.add_service(service)
      instance.add_service(service)

      expect(instance.services).to match_array([service])
    end

    it 'automatically assigns incrementing instance_ids to services' do
      accessory = RubyHome::Accessory.new
      service_1 = RubyHome::Service.new(
        accessory: accessory,
        name: 'fan',
        description: 'Accessory Information',
        uuid: '00000040-0000-1000-8000-0026BB765291'
      )
      service_2 = RubyHome::Service.new(
        accessory: accessory,
        name: 'fan',
        description: 'Accessory Information',
        uuid: '00000040-0000-1000-8000-0026BB765291'
      )

      instance.add_service(service_1)
      instance.add_service(service_2)

      expect(service_1.instance_id).to eql(1)
      expect(service_2.instance_id).to eql(2)
    end
  end

  describe '#add_characteristic' do
    it 'adds a characteristic to services characteristic' do
      accessory = RubyHome::Accessory.new
      service = RubyHome::Service.new(
        accessory: accessory,
        name: 'fan',
        description: 'Accessory Information',
        uuid: '00000040-0000-1000-8000-0026BB765291'
      )
      characteristic = RubyHome::Characteristic.new(
        uuid: '00000025-0000-1000-8000-0026BB765291',
        name: :on,
        description: 'On',
        format: 'bool',
        unit: nil,
        properties: ['securedRead', 'securedWrite'],
        service: service
      )

      instance.add_characteristic(characteristic)

      expect(instance.characteristics).to match_array([characteristic])
    end

    it 'persists a characteristic' do
      accessory = RubyHome::Accessory.new
      service = RubyHome::Service.new(
        accessory: accessory,
        name: 'fan',
        description: 'Accessory Information',
        uuid: '00000040-0000-1000-8000-0026BB765291'
      )
      characteristic = RubyHome::Characteristic.new(
        uuid: '00000025-0000-1000-8000-0026BB765291',
        name: :on,
        description: 'On',
        format: 'bool',
        unit: nil,
        properties: ['securedRead', 'securedWrite'],
        service: service
      )

      instance.add_characteristic(characteristic)
      instance.reload

      expect(instance.characteristics).to match_array([characteristic])
    end

    it 'doesnt persist a previously persisted characteristic' do
      accessory = RubyHome::Accessory.new
      service = RubyHome::Service.new(
        accessory: accessory,
        name: 'fan',
        description: 'Accessory Information',
        uuid: '00000040-0000-1000-8000-0026BB765291'
      )
      characteristic = RubyHome::Characteristic.new(
        uuid: '00000025-0000-1000-8000-0026BB765291',
        name: :on,
        description: 'On',
        format: 'bool',
        unit: nil,
        properties: ['securedRead', 'securedWrite'],
        service: service
      )

      instance.add_characteristic(characteristic)
      instance.add_characteristic(characteristic)

      expect(instance.characteristics).to match_array([characteristic])
    end

    it 'automatically assigns incrementing instance_ids to characteristics' do
      accessory = RubyHome::Accessory.new
      service = RubyHome::Service.new(
        accessory: accessory,
        name: 'fan',
        description: 'Accessory Information',
        uuid: '00000040-0000-1000-8000-0026BB765291'
      )
      characteristic_1 = RubyHome::Characteristic.new(
        uuid: '00000025-0000-1000-8000-0026BB765291',
        name: :on,
        description: 'On',
        format: 'bool',
        unit: nil,
        properties: ['securedRead', 'securedWrite'],
        service: service
      )
      characteristic_2 = RubyHome::Characteristic.new(
        uuid: '000000AF-0000-1000-8000-0026BB765291',
        name: :current_fan_state,
        description: 'Current Fan State',
        format: 'uint8',
        unit: nil,
        properties: ['read', 'cnotify'],
        service: service
      )

      instance.add_characteristic(characteristic_1)
      instance.add_characteristic(characteristic_2)

      expect(service.instance_id).to eql(1)
      expect(characteristic_1.instance_id).to eql(2)
      expect(characteristic_2.instance_id).to eql(3)
    end
  end
end
