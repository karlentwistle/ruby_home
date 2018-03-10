Dir[File.dirname(__FILE__) + '/characteristics/*.rb'].each { |file| require file }

module Rubyhome
  class Characteristic
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
  end
end
