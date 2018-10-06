module RubyHome
  class Characteristic
    include Wisper::Publisher

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

    def subscribe_socket(socket, *events, &block)
      return if local_sockets.include?(socket)

      local_sockets << socket
      on(*events, &block)
    end

    def local_sockets
      @local_sockets ||= []
    end

    def value=(new_value)
      return if name == :identify

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
