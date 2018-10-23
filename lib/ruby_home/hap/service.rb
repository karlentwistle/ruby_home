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
    end

    attr_reader :accessory, :characteristics, :primary, :hidden, :name, :description, :uuid
    attr_accessor :instance_id

    def characteristic(characteristic_name)
      characteristics.find do |characteristic|
        characteristic.name == characteristic_name
      end
    end

    def save
      IdentifierCache.instance.add_service(self)
    end

    def inspect
      {
        primary: primary,
        hidden: hidden,
        characteristics: characteristics
      }
    end

    def ==(other)
      self.class == other.class &&
        self.primary == other.primary &&
        self.hidden == other.hidden &&
        self.name == other.name &&
        self.description == other.description &&
        self.uuid == other.uuid &&
        self.characteristics == other.characteristics
    end
  end
end
