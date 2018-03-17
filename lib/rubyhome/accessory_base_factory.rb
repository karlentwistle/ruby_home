require_relative 'hap/accessory'
require_relative 'hap/service'
require_relative 'characteristic_helper'

module Rubyhome
  class AccessoryBaseFactory
    def initialize(accessory: Rubyhome::Accessory.new, **options)
      @accessory = accessory
      @accessory_information = AccessoryInformationFactory.new(
        accessory: accessory, service: service, **options
      )
      @attributes = CharacteristicHelper.characteristics(self.class.service_class).map(&:attribute_name)
      options.slice(*attributes).each do |key, value|
        self.send("#{key}=", value)
      end
    end

    attr_reader :accessory, :attributes, :accessory_information

    def service
      @service ||= self.class.service_class.new(accessory: accessory)
    end

    def characteristics
      attributes.map { |attribute| send(attribute) }
    end

    def save
      accessory_information.save

      IdentifierCache.add_accessory(accessory)
      IdentifierCache.add_service(service)

      characteristics.compact.each do |characteristic|
        if characteristic.valid?
          IdentifierCache.add_characteristic(characteristic)
        end
      end
    end
  end
end

