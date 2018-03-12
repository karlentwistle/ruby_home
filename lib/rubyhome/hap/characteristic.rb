require 'wisper'
Dir[File.dirname(__FILE__) + '/characteristics/*.rb'].each { |file| require file }

module Rubyhome
  class Characteristic
    include Wisper::Publisher

    PROPERTIES = {
      'cnotify' => 'ev',
      'read' => 'pr',
      'uncnotify' => nil,
      'write' => 'pw',
    }

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

    private

      def default_value
        return if is_a?(Identify)
        return false if format == 'bool'
      end
  end
end
