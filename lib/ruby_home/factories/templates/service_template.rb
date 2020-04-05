module RubyHome
  class ServiceTemplate
    FILEPATH = (File.dirname(__FILE__) + '/../../config/services.yml').freeze
    DATA = YAML.load_file(FILEPATH).freeze

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

    def initialize(name:, description:, uuid:, optional_characteristics_uuids:, required_characteristics_uuids:)
      @name = name
      @description = description
      @uuid = uuid
      @optional_characteristics_uuids = optional_characteristics_uuids
      @required_characteristics_uuids = required_characteristics_uuids
    end

    attr_reader :name, :description, :uuid, :optional_characteristics_uuids, :required_characteristics_uuids

    def optional_characteristics
      @optional_characteristics ||= optional_characteristics_uuids.map do |uuid|
        CharacteristicTemplate.find_by(uuid: uuid)
      end
    end

    def required_characteristics
      @required_characteristics ||= required_characteristics_uuids.map do |uuid|
        CharacteristicTemplate.find_by(uuid: uuid)
      end
    end
  end
end
