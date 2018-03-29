require 'wisper'

module Rubyhome
  class Characteristic
    include Wisper::Publisher

    PROPERTIES = {
      'cnotify' => 'ev',
      'read' => 'pr',
      'uncnotify' => nil,
      'write' => 'pw',
    }.freeze

    def initialize(uuid:, name:, description:, format:, unit:, permissions:, properties:, constraints:, service: , value: nil)
      @service = service
      @value = value
      @uuid = uuid
      @name = name
      @description = description
      @format = format
      @unit = unit
      @permissions = permissions
      @properties = properties
      @constraints = constraints
    end

    attr_reader :service, :value, :uuid, :name, :description, :format, :unit, :permissions, :properties, :constraints
    attr_accessor :instance_id

    def accessory
      service.accessory
    end

    def accessory_id
      accessory.id
    end

    def service_iid
      service.instance_id
    end

    def value=(new_value)
      @value = new_value
      broadcast(:updated, new_value)
    end

    def inspect
      {
        name: name,
        value: value,
        accessory_id: accessory_id,
        service_iid: service_iid,
        instance_id: instance_id
      }
    end

    def save
      IdentifierCache.add_accessory(accessory)
      IdentifierCache.add_characteristic(self)
    end
  end
end
