require_relative '../models/characteristic'
require_relative '../models/service'
require_relative 'accessory_information_builder'

module Rubyhome
  class FanBuilder
    def initialize
      @accessory = Accessory.create!
      @service = Rubyhome::Service::Fan.new(accessory: @accessory)
    end

    attr_reader :service

    def characteristics
      [
        Rubyhome::Characteristic::Name.new(value: 'Fan', service: service),
        Rubyhome::Characteristic::On.new(service: service),
      ]
    end

    def information
      AccessoryInformationBuilder.new(accessory: @accessory)
    end

    def save
      information.save
      characteristics.each(&:save!)
    end
  end
end
