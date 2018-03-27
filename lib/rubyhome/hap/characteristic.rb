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

    FROM_UUID = Hash[descendants.map do |characteristic|
      [characteristic.uuid, characteristic]
    end].freeze

    def initialize(service: , value: nil)
      @service = service
      @value = value
    end

    attr_reader :service, :value, :user_defined
    attr_accessor :instance_id

    def accessory
      service.accessory
    end

    def accessory_id
      accessory.id
    end

    def user_defined?
      !!@user_defined
    end

    def value=(new_value)
      @value = new_value
      @user_defined = true
      broadcast(:value_updated, new_value)
    end

    def value
      @value || default_value
    end

    def uuid
      self.class.uuid
    end

    def name
      self.class.name
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
