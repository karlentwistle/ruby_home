require 'wisper'
Dir[File.dirname(__FILE__) + '/characteristics/*.rb'].each { |file| require file }

module Rubyhome
  class Characteristic
    include Wisper::Publisher

    def self.descendants
      ObjectSpace.each_object(Class).select { |klass| klass < self }
    end

    PROPERTIES = {
      'cnotify' => 'ev',
      'read' => 'pr',
      'uncnotify' => nil,
      'write' => 'pw',
    }.freeze

    FROM_UUID = Hash[descendants.map do |klass_descendant|
      [klass_descendant.uuid, klass_descendant]
    end].freeze

    def initialize(service: , value: nil)
      @service = service
      @value = value
    end

    attr_reader :service, :value
    attr_accessor :instance_id

    def accessory
      service.accessory
    end

    def accessory_id
      accessory.id
    end

    def value=(new_value)
      @value = new_value
      broadcast(:value_updated, new_value)
    end

    def value
      @value || default_value
    end

    def uuid
      self.class.uuid
    end

    def attribute_name
      name.downcase
    end

    def ==(other)
      other.class == self.class && other.state == self.state
    end

    def valid?
      return true if is_a?(Identify)
      value != nil
    end

    protected

      def state
        self.instance_variables.map { |variable| self.instance_variable_get variable }
      end

    private

      DEFAULT_VALUES = {
        FirmwareRevision => '1.0',
        Identify => nil,
        Manufacturer => 'Default-Manufacturer',
        Model => 'Default-Model',
        Name => 'Rubyhome',
        SerialNumber => 'Default-SerialNumber',
      }.freeze

      def default_value
        DEFAULT_VALUES.fetch(self.class) do
          false if format == 'bool'
        end
      end
  end
end
