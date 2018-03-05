require_relative '../models/characteristic'
require_relative '../models/service'
require_relative 'accessory_information_builder'

module Rubyhome
  class FanBuilder
    def initialize
      @service = Rubyhome::Service::Fan.new(accessory_id: 2)
    end

    attr_reader :service

    def characteristics
      [
        Rubyhome::Characteristic::Name.new(value: 'Fan', service: service),
        Rubyhome::Characteristic::On.new(service: service),
      ]
    end

    def information
      AccessoryInformationBuilder.new(accessory_id: 2)
    end

    def save
      information.save
      characteristics.each(&:save!)
    end
  end
end
