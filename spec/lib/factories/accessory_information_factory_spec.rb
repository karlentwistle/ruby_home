require 'spec_helper'

RSpec.describe Rubyhome::AccessoryInformationFactory do
  describe '.new' do
    it 'allows customization of manufacturer' do
      accessory_information = Rubyhome::AccessoryInformationFactory.new(manufacturer: 'Acme')
      expect(accessory_information.manufacturer).to eq(
        Rubyhome::Characteristic::Manufacturer.new(value: 'Acme', service: accessory_information.service)
      )
    end

    it 'allows customization of model' do
      accessory_information = Rubyhome::AccessoryInformationFactory.new(model: 'A1234')
      expect(accessory_information.model).to eq(
        Rubyhome::Characteristic::Model.new(value: 'A1234', service: accessory_information.service)
      )
    end

    it 'allows customization of name' do
      accessory_information = Rubyhome::AccessoryInformationFactory.new(name: 'Rubyhome')
      expect(accessory_information.name).to eq(
        Rubyhome::Characteristic::Name.new(value: 'Rubyhome', service: accessory_information.service)
      )
    end

    it 'allows customization of serial_number' do
      accessory_information = Rubyhome::AccessoryInformationFactory.new(serial_number: '1A2B3C4D5E6F')
      expect(accessory_information.serial_number).to eq(
        Rubyhome::Characteristic::SerialNumber.new(value: '1A2B3C4D5E6F', service: accessory_information.service)
      )
    end

    it 'allows customization of firmware_revision' do
      accessory_information = Rubyhome::AccessoryInformationFactory.new(firmware_revision: '1.0.0')
      expect(accessory_information.firmware_revision).to eq(
        Rubyhome::Characteristic::FirmwareRevision.new(value: '1.0.0', service: accessory_information.service)
      )
    end

    it 'allows customization of hardware_revision' do
      accessory_information = Rubyhome::AccessoryInformationFactory.new(hardware_revision: '1.0.0')
      expect(accessory_information.hardware_revision).to eq(
        Rubyhome::Characteristic::HardwareRevision.new(value: '1.0.0', service: accessory_information.service)
      )
    end

    it 'allows customization of accessory_flags' do
      accessory_information = Rubyhome::AccessoryInformationFactory.new(accessory_flags: '0x0002')
      expect(accessory_information.accessory_flags).to eq(
        Rubyhome::Characteristic::AccessoryFlags.new(value: '0x0002', service: accessory_information.service)
      )
    end
  end

  describe '#service' do
    it 'automatically generates a service' do
      accessory_information = Rubyhome::AccessoryInformationFactory.new
      expect(accessory_information.service).to be_a(Rubyhome::Service::AccessoryInformation)
    end
  end

  describe '#manufacturer' do
    it 'can be customized' do
      accessory_information = Rubyhome::AccessoryInformationFactory.new(manufacturer: 'Acme')
      expect(accessory_information.manufacturer).to eq(
        Rubyhome::Characteristic::Manufacturer.new(value: 'Acme', service: accessory_information.service)
      )
    end

    it 'provides a default' do
      accessory_information = Rubyhome::AccessoryInformationFactory.new
      expect(accessory_information.manufacturer).to have_attributes(
        value: 'Default-Manufacturer', service: accessory_information.service
      )
    end
  end

  describe '#model' do
    it 'can be customized' do
      accessory_information = Rubyhome::AccessoryInformationFactory.new(model: 'A1234')
      expect(accessory_information.model).to eq(
        Rubyhome::Characteristic::Model.new(value: 'A1234', service: accessory_information.service)
      )
    end

    it 'provides a default' do
      accessory_information = Rubyhome::AccessoryInformationFactory.new
      expect(accessory_information.model).to have_attributes(
        value: 'Default-Model', service: accessory_information.service
      )
    end
  end

  describe '#name' do
    it 'can be customized' do
      accessory_information = Rubyhome::AccessoryInformationFactory.new(name: 'Rubyhome')
      expect(accessory_information.name).to eq(
        Rubyhome::Characteristic::Name.new(value: 'Rubyhome', service: accessory_information.service)
      )
    end

    it 'provides a default' do
      accessory_information = Rubyhome::AccessoryInformationFactory.new
      expect(accessory_information.name).to have_attributes(
        value: 'Rubyhome', service: accessory_information.service
      )
    end
  end

  describe '#serial_number' do
    it 'can be customized' do
      accessory_information = Rubyhome::AccessoryInformationFactory.new(serial_number: '1A2B3C4D5E6F')
      expect(accessory_information.serial_number).to eq(
        Rubyhome::Characteristic::SerialNumber.new(value: '1A2B3C4D5E6F', service: accessory_information.service)
      )
    end

    it 'provides a default' do
      accessory_information = Rubyhome::AccessoryInformationFactory.new
      expect(accessory_information.serial_number).to have_attributes(
        value: 'Default-SerialNumber', service: accessory_information.service
      )
    end
  end

  describe '#firmware_revision' do
    it 'can be customized' do
      accessory_information = Rubyhome::AccessoryInformationFactory.new(firmware_revision: '1.0.0')
      expect(accessory_information.firmware_revision).to eq(
        Rubyhome::Characteristic::FirmwareRevision.new(value: '1.0.0', service: accessory_information.service)
      )
    end

    it 'provides a default' do
      accessory_information = Rubyhome::AccessoryInformationFactory.new
      expect(accessory_information.firmware_revision).to have_attributes(
        value: '1.0', service: accessory_information.service
      )
    end
  end

  describe '#hardware_revision' do
    it 'can be customized' do
      accessory_information = Rubyhome::AccessoryInformationFactory.new(hardware_revision: '1.0.0')
      expect(accessory_information.hardware_revision).to eq(
        Rubyhome::Characteristic::HardwareRevision.new(value: '1.0.0', service: accessory_information.service)
      )
    end
  end

  describe '#accessory_flags' do
    it 'can be customized' do
      accessory_information = Rubyhome::AccessoryInformationFactory.new(accessory_flags: '0x0002')
      expect(accessory_information.accessory_flags).to eq(
        Rubyhome::Characteristic::AccessoryFlags.new(value: '0x0002', service: accessory_information.service)
      )
    end
  end
end
