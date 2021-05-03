module RubyHome
  class ServiceTemplate
    FILENAMES = %w[services.yml manual_services.yml].freeze
    FILEPATHS = FILENAMES.map { |filename| File.join(__dir__, "..", "..", "config", filename) }.freeze
    DATA = FILEPATHS.flat_map { |filepath| YAML.load_file(filepath) }.freeze

    def self.all
      @all ||= DATA.map { |data| new(**data) }
    end

    def self.find_by(options)
      all.find do |characteristic|
        options.all? do |key, value|
          characteristic.send(key) == value
        end
      end
    end

    def initialize(name:, description:, uuid:, optional_characteristic_names:, required_characteristic_names:)
      @name = name
      @description = description
      @uuid = uuid
      @optional_characteristic_names = optional_characteristic_names
      @required_characteristic_names = required_characteristic_names
    end

    attr_reader :name, :description, :uuid, :optional_characteristic_names, :required_characteristic_names

    def optional_characteristics
      @optional_characteristics ||= optional_characteristic_names.map do |name|
        CharacteristicTemplate.find_by(name: name)
      end
    end

    def required_characteristics
      @required_characteristics ||= required_characteristic_names.map do |name|
        CharacteristicTemplate.find_by(name: name)
      end
    end
  end
end
