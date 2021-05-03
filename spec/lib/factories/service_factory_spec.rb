require "spec_helper"

RSpec.describe RubyHome::ServiceFactory do
  describe ".create" do
    it "creates a service with the specified name" do
      service = RubyHome::ServiceFactory.create(:fan)

      expect(service.name).to eql(:fan)
    end

    it "assigns an accessory" do
      service = RubyHome::ServiceFactory.create(:fan)

      expect(service.accessory).to be_a(RubyHome::Accessory)
    end

    it "assigns the service to the accessory" do
      service = RubyHome::ServiceFactory.create(:thermostat)
      accessory = service.accessory

      expect(accessory.services).to include(service)
    end

    it "assigns the correct description" do
      service = RubyHome::ServiceFactory.create(:air_purifier)

      expect(service.description).to eql("Air Purifier")
    end

    it "assigns the correct uuid" do
      service = RubyHome::ServiceFactory.create(:air_quality_sensor)

      expect(service.uuid).to eql("0000008D-0000-1000-8000-0026BB765291")
    end

    it "assigns required characteristics" do
      service = RubyHome::ServiceFactory.create(:fan)

      expect(service.characteristics).to include(
        an_object_having_attributes(name: :on)
      )
    end

    it "assigns accessory information to a service's accessory" do
      service = RubyHome::ServiceFactory.create(:fan)

      expect(service.accessory.services).to include(
        an_object_having_attributes(name: :fan),
        an_object_having_attributes(name: :accessory_information)
      )
    end

    it "skips assigning accessory information to a accessory_information service" do
      service = RubyHome::ServiceFactory.create(:accessory_information)

      expect(service.accessory.services).to include(
        an_object_having_attributes(name: :accessory_information)
      )
    end

    it "allows accessory information to be overridden" do
      service = RubyHome::ServiceFactory.create(
        :fan,
        firmware_revision: "custom_firmware_revision",
        manufacturer: "custom_manufacturer",
        model: "custom_model",
        name: "custom_name",
        serial_number: "custom_serial_number"
      )

      expect(service.accessory.characteristics).to include(
        an_object_having_attributes(
          name: :firmware_revision,
          value: "custom_firmware_revision"
        ),
        an_object_having_attributes(
          name: :manufacturer,
          value: "custom_manufacturer"
        ),
        an_object_having_attributes(
          name: :model,
          value: "custom_model"
        ),
        an_object_having_attributes(
          name: :name,
          value: "custom_name"
        ),
        an_object_having_attributes(
          name: :serial_number,
          value: "custom_serial_number"
        )
      )
    end

    it "assigns required characteristics values if they're specified" do
      service = RubyHome::ServiceFactory.create(
        :thermostat,
        current_temperature: 18,
        target_temperature: 20
      )

      expect(service.characteristics).to include(
        an_object_having_attributes(name: :current_temperature, value: 18),
        an_object_having_attributes(name: :target_temperature, value: 20)
      )
    end

    it "assigns optional characteristics if they're specified" do
      service = RubyHome::ServiceFactory.create(
        :fan,
        name: "Fan",
        rotation_speed: 1
      )

      expect(service.characteristics).to include(
        an_object_having_attributes(name: :rotation_speed, value: 1),
        an_object_having_attributes(name: :name, value: "Fan")
      )
    end

    it "ignores identify characteristic even if it's specified" do
      service = RubyHome::ServiceFactory.create(
        :accessory_information,
        identify: "Ignore me"
      )

      expect(service.characteristics).to include(
        an_object_having_attributes(name: :identify, value: true)
      )
    end

    it "persists the service within identifier cache" do
      service = RubyHome::ServiceFactory.create(:fan)

      expect(RubyHome::IdentifierCache.all).to include(
        an_object_having_attributes(
          accessory_id: 1,
          instance_id: 1,
          uuid: "00000040-0000-1000-8000-0026BB765291",
          subtype: "default"
        )
      )
    end

    it "doesnt allow two services within the same accessory with the same subtype" do
      fan_1 = RubyHome::ServiceFactory.create(:fan)

      expect {
        RubyHome::ServiceFactory.create(:fan, accessory: fan_1.accessory)
      }.to raise_error(RubyHome::DuplicateServiceError)
    end

    it "allows two services within the same accessory with different subtypes" do
      garage_door_opener = RubyHome::Accessory.new
      security_light = RubyHome::ServiceFactory.create(:lightbulb, subtype: "security_light", accessory: garage_door_opener)
      backlight = RubyHome::ServiceFactory.create(:lightbulb, subtype: "backlight", accessory: garage_door_opener)

      expect(RubyHome::IdentifierCache.all).to include(
        an_object_having_attributes(
          accessory_id: 1,
          instance_id: 1,
          uuid: "00000043-0000-1000-8000-0026BB765291",
          subtype: "security_light"
        )
      )

      expect(RubyHome::IdentifierCache.all).to include(
        an_object_having_attributes(
          accessory_id: 1,
          instance_id: 11,
          uuid: "00000043-0000-1000-8000-0026BB765291",
          subtype: "backlight"
        )
      )
    end

    it "assigns the same instance_id to services within an accessory" do
      RubyHome::IdentifierCache.create(
        accessory_id: 1,
        instance_id: 10,
        uuid: "00000040-0000-1000-8000-0026BB765291",
        subtype: "default"
      )

      service = RubyHome::ServiceFactory.create(:fan)

      expect(service.instance_id).to eql(10)
    end

    it "doesnt persist existing identifiers again" do
      RubyHome::IdentifierCache.create(
        accessory_id: 1,
        instance_id: 10,
        uuid: "00000040-0000-1000-8000-0026BB765291",
        subtype: "default"
      )

      RubyHome::ServiceFactory.create(:fan)

      expect(RubyHome::IdentifierCache.all.count).to eql(9)
    end
  end
end
