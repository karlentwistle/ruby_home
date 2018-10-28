module RubyHome
  class CharacteristicTemplate
    FILEPATH = (File.dirname(__FILE__) + '/../../config/characteristics.yml').freeze
    DATA = YAML.load_file(FILEPATH).freeze

    def self.all
      @@all ||= DATA.map { |data| new(data) }
    end

    def self.find_by(options)
      all.find do |characteristic|
        options.all? do |key, value|
          characteristic.send(key) == value
        end
      end
    end

    def initialize(name:, description:, uuid:, format:, unit:, permissions:, properties:, constraints: )
      @name = name
      @description = description
      @uuid = uuid
      @format = format
      @unit = unit
      @permissions = permissions
      @properties = properties
      @constraints = constraints
    end

    attr_reader :name, :description, :uuid, :format, :unit, :permissions, :properties

    def constraints
      @constraints || {}
    end

    def to_hash
      {
        name: name,
        description: description,
        uuid: uuid,
        format: format,
        unit: unit,
        properties: properties,
      }
    end
  end
end
