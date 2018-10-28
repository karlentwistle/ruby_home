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

    it 'assigns required characteristics to the service' do
      service = RubyHome::ServiceFactory.create(:thermostat)

      expect(service.characteristics.count).to eql(5)
    end

    it 'assigns optional characteristics to the service' do
      service = RubyHome::ServiceFactory.create(:fan, name: 'Fan')

      expect(service.characteristics.count).to eql(2)
    end
  end
end
