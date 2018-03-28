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
      self.value = value
    end

    attr_reader :service, :value
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
      broadcast(:value_updated, new_value)
    end

    def uuid
      self.class.uuid
    end

    def format
      self.class.format
    end

    def name
      self.class.name
    end

    def save
      IdentifierCache.add_accessory(accessory)
      IdentifierCache.add_characteristic(self)
    end
  end
end
