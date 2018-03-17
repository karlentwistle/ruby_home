require_relative 'accessory_base_factory'
require_relative 'characteristic_helper'
require_relative 'hap/accessory'
require_relative 'hap/service'

module Rubyhome
  class FanFactory < AccessoryBaseFactory
    def self.service_class
      Service::Fan
    end

    CharacteristicHelper.define_characteristics(self)
  end
end

