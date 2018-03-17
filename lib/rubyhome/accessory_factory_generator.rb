require_relative 'accessory_base_factory'
require_relative 'characteristic_helper'
require_relative 'hap/accessory'
require_relative 'hap/service'

module Rubyhome
  module AccessoryFactoryGenerator
    GENERATED_SERVICES = (
      Service.descendants - [Rubyhome::Service::AccessoryInformation]
    ).freeze

    def self.build
      GENERATED_SERVICES.each do |class_name|
        self.create_factory_class(class_name)
      end
    end

    def self.create_factory_class(class_name)
      klass = Class.new(AccessoryBaseFactory)
      klass.define_singleton_method(:service_class) { class_name }
      CharacteristicHelper.define_characteristics(klass)
      Rubyhome.const_set(factory_name(class_name), klass)
    end

    def self.factory_name(class_name)
      demodulize(class_name) + "Factory"
    end

    def self.demodulize(path)
      path = path.to_s
      if i = path.rindex("::")
        path[(i + 2)..-1]
      else
        path
      end
    end

    AccessoryFactoryGenerator.build
  end
end
