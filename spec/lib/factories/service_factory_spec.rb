require 'spec_helper'

RSpec.describe RubyHome::ServiceFactory do
  describe '.create' do
    it 'creates a service with the specified name' do
      service = RubyHome::ServiceFactory.create(:fan)

      expect(service.name).to eql(:fan)
    end

    it 'assigns an accessory' do
      service = RubyHome::ServiceFactory.create(:fan)

      expect(service.accessory).to be_a(RubyHome::Accessory)
    end

    it "assigns the service to the accessory" do
      service = RubyHome::ServiceFactory.create(:thermostat)
      accessory = service.accessory

      expect(accessory.services).to include(service)
    end

    it 'assigns the correct description' do
      service = RubyHome::ServiceFactory.create(:air_purifier)

      expect(service.description).to eql('Air Purifier')
    end

    it 'assigns the correct uuid' do
      service = RubyHome::ServiceFactory.create(:air_quality_sensor)

      expect(service.uuid).to eql('0000008D-0000-1000-8000-0026BB765291')
    end

    it 'assigns required characteristics' do
      service = RubyHome::ServiceFactory.create(:fan)

      expect(service.characteristics).to include(
        an_object_having_attributes(name: :on)
      )
    end

    it 'assigns accessory information to a service\'s accessory' do
      service = RubyHome::ServiceFactory.create(:fan)

      expect(service.accessory.services).to include(
        an_object_having_attributes(name: :fan),
        an_object_having_attributes(name: :accessory_information),
      )
    end

    it 'skips assigning accessory information to a accessory_information service' do
      service = RubyHome::ServiceFactory.create(:accessory_information)

      expect(service.accessory.services).to include(
        an_object_having_attributes(name: :accessory_information),
      )
    end

    it 'allows accessory information to be overridden' do
      service = RubyHome::ServiceFactory.create(
        :fan,
        firmware_revision: 'custom_firmware_revision',
        identify: 'custom_identify',
        manufacturer: 'custom_manufacturer',
        model: 'custom_model',
        name: 'custom_name',
        serial_number: 'custom_serial_number'
      )

      expect(service.accessory.characteristics).to include(
        an_object_having_attributes(
          name: :firmware_revision,
          value: 'custom_firmware_revision'
        ),
        an_object_having_attributes(
          name: :identify,
          value: 'custom_identify'
        ),
        an_object_having_attributes(
          name: :manufacturer,
          value: 'custom_manufacturer'
        ),
        an_object_having_attributes(
          name: :model,
          value: 'custom_model'
        ),
        an_object_having_attributes(
          name: :name,
          value: 'custom_name'
        ),
        an_object_having_attributes(
          name: :serial_number,
          value: 'custom_serial_number'
        )
      )
    end

    it 'assigns required characteristics values if they\'re specified' do
      service = RubyHome::ServiceFactory.create(
        :thermostat,
        current_temperature: 18,
        target_temperature: 20
      )

      expect(service.characteristics).to include(
        an_object_having_attributes(name: :current_temperature, value: 18),
        an_object_having_attributes(name: :target_temperature, value: 20),
      )
    end

    it 'assigns optional characteristics if they\'re specified' do
      service = RubyHome::ServiceFactory.create(
        :fan,
        name: 'Fan',
        rotation_speed: 1
      )

      expect(service.characteristics).to include(
        an_object_having_attributes(name: :rotation_speed, value: 1),
        an_object_having_attributes(name: :name, value: 'Fan')
      )
    end
  end
end
