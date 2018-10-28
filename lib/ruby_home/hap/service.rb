module RubyHome
  class Service
    def initialize(accessory: , primary: false, hidden: false, name:, description:, uuid:)
      @accessory = accessory
      @primary = primary
      @hidden = hidden
      @name = name
      @description = description
      @uuid = uuid
      @characteristics = []
      @instance_id = accessory.next_available_instance_id
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

    def characteristic(characteristic_name)
      characteristics.find do |characteristic|
        characteristic.name == characteristic_name
      end
    end
  end
end
