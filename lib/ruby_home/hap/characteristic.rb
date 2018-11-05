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

    attr_reader(
      :service,
      :value,
      :uuid,
      :name,
      :description,
      :format,
      :unit,
      :properties,
      :instance_id
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

    def value=(new_value)
      return if name == :identify
      @value = new_value
      broadcast(:after_update, self)
    end
  end
end
