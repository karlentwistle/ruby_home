module RubyHome
  class CharacteristicTemplate
    FILENAMES = %w[characteristics.yml manual_characteristics.yml].freeze
    FILEPATHS = FILENAMES.map { |filename| File.join(__dir__, "..", "..", "config", filename) }.freeze
    DATA = FILEPATHS.flat_map { |filepath| YAML.load_file(filepath) }.freeze

    def self.all
      @@all ||= DATA.map { |data| new(**data) }
    end

    def self.find_by(options)
      all.find do |characteristic|
        options.all? do |key, value|
          characteristic.send(key) == value
        end
      end
    end

    def initialize(name:, description:, uuid:, format:, unit:, properties:, constraints:)
      @name = name
      @description = description
      @uuid = uuid
      @format = format
      @unit = unit
      @properties = properties
      @constraints = constraints
    end

    attr_reader :name, :description, :uuid, :format, :unit, :properties

    def constraints
      @constraints || {}
    end
  end
end
