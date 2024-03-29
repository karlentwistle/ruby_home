require_relative "characteristic_collection"

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
      "cnotify" => "ev",
      "read" => "pr",
      "uncnotify" => nil,
      "write" => "pw"
    }.freeze

    def initialize(uuid:, name:, description:, format:, unit:, properties:, constraints:, service:, value_object:)
      @uuid = uuid
      @name = name
      @description = description
      @format = format
      @unit = unit
      @properties = properties
      @constraints = constraints
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
      :constraints,
      :instance_id,
      :value_object
    )

    def instance_id=(new_id)
      raise DuplicateCharacteristicError if accessory.contains_instance_id?(new_id)

      @instance_id = new_id
    end

    def accessory
      service.accessory
    end

    def accessory_id
      accessory.id
    end

    def service_iid
      service.instance_id
    end

    def valid_values
      constraints.fetch("ValidValues", {}).keys.map(&:to_i)
    end

    def minimum_value
      return unless numeric_format?

      constraints["MinimumValue"]
    end

    def maximum_value
      return unless numeric_format?

      constraints["MaximumValue"]
    end

    def step_value
      return unless numeric_format?

      constraints["StepValue"]
    end

    NUMERIC_FORMATS = ["float", "uint8", "int32", "uint32"].freeze

    def numeric_format?
      NUMERIC_FORMATS.include?(format)
    end

    def method_missing(method_name, *args, &block)
      value.send(method_name, *args, &block)
    end

    def respond_to_missing?(method_name, *args)
      value.respond_to?(method_name, *args) || super
    end

    def value
      value_object.value
    end

    def value=(new_value)
      value_object.value = new_value
      broadcast(:after_update, value)
    end
  end
end
