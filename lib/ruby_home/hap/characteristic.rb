module RubyHome
  class Characteristic
    include Wisper::Publisher

    public :local_registrations

    def unsubscribe(*listeners)
      local_registrations.delete_if do |registration|
        listeners.include?(registration.listener)
      end
    end

    def after_update(&block)
      on(:after_update, &block)
    end

    PROPERTIES = {
      'cnotify' => 'ev',
      'read' => 'pr',
      'uncnotify' => nil,
      'write' => 'pw',
    }.freeze

    def initialize(uuid:, name:, description:, format:, unit:, properties:, service: , value: nil)
      @uuid = uuid
      @name = name
      @description = description
      @format = format
      @unit = unit
      @properties = properties
      @service = service
      @value = value
    end

    attr_reader :service, :value, :uuid, :name, :description, :format, :unit, :properties
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
      return if name == :identify
      @value = new_value
      broadcast(:after_update, self)
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
