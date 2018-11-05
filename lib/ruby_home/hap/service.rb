module RubyHome
  class DuplicateServiceError < StandardError; end

  class Service
    def initialize(accessory: , primary: false, hidden: false, name:, description:, uuid:)
      @accessory = accessory
      @primary = primary
      @hidden = hidden
      @name = name
      @description = description
      @uuid = uuid
      @characteristics = []
    end

    attr_reader(
      :accessory,
      :characteristics,
      :primary,
      :hidden,
      :name,
      :description,
      :uuid,
      :instance_id
    )

    def instance_id=(new_id)
      raise DuplicateServiceError if accessory.contains_instance_id?(new_id)

      @instance_id = new_id
    end

    delegate :id, to: :accessory, prefix: true

    def characteristic(characteristic_name)
      characteristics.find do |characteristic|
        characteristic.name == characteristic_name
      end
    end
  end
end
