module RubyHome
  class DuplicateCharacteristicError < StandardError; end

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

    def initialize(uuid:, name:, description:, format:, unit:, properties:, service: , value_object: )
      @uuid = uuid
      @name = name
      @description = description
      @format = format
      @unit = unit
      @properties = properties
      @service = service
      @value_object = value_object
    end

    attr_reader(
      :service,
      :uuid,
      :name,
      :description,
      :format,
      :unit,
      :properties,
      :instance_id,
      :value_object,
    )

    def instance_id=(new_id)
      raise DuplicateCharacteristicError if accessory.contains_instance_id?(new_id)

      @instance_id = new_id
    end

    delegate :accessory, to: :service
    delegate :id, to: :accessory, prefix: true

    def service_iid
      service.instance_id
    end

    def value
      value_object.value
    end

    def value=(new_value)
      value_object.value = new_value
      broadcast(:after_update, self)
    end
  end
end
