require_relative '../hap/accessory'
require_relative '../hap/service'
require_relative 'characteristic_helper'

module Rubyhome
  class AccessoryInformationFactory
    def self.service_class
      Service::AccessoryInformation
    end

    def initialize(accessory: Rubyhome::Accessory.new, service: nil, **options)
      @accessory = accessory
      @service ||= self.class.service_class.new(accessory: accessory)
      @attributes = CharacteristicHelper.characteristics(self.class.service_class).map(&:attribute_name)
      options.slice(*attributes).each do |key, value|
        send("#{key}=", value)
      end
    end

    attr_reader :accessory, :attributes, :service

    CharacteristicHelper.define_characteristics(self)

    def characteristics
      attributes.map { |attribute| send(attribute) }
    end

    def save
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
