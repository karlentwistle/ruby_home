Dir[File.dirname(__FILE__) + '/services/*.rb'].each { |file| require file }
require_relative 'characteristic'

module Rubyhome
  class Service
    def self.descendants
      ObjectSpace.each_object(Class).select { |klass| klass < self }
    end

    def initialize(accessory: , primary: false, hidden: false, **options)
      @accessory = accessory
      @primary = primary
      @hidden = hidden
      @characteristics = []

      options.each do |key, value|
        send("#{key}=", value)
      end
    end

    attr_reader :accessory, :characteristics, :primary, :hidden
    attr_accessor :instance_id

    def uuid
      self.class.uuid
    end

    def characteristic(characteristic_name)
      characteristics.find do |characteristic|
        characteristic.name == characteristic_name
      end
    end

    def required_characteristics
      @required_characteristics ||= self.class.required_characteristic_uuids.map do |characteristic_uuid|
        Rubyhome::Characteristic::FROM_UUID[characteristic_uuid]
      end.map {|characteristic| characteristic.new(service: self)}
    end

    def optional_characteristics
      @optional_characteristics ||= self.class.optional_characteristic_uuids.map do |characteristic_uuid|
        Rubyhome::Characteristic::FROM_UUID[characteristic_uuid]
      end.map {|characteristic| characteristic.new(service: self)}
    end

    def available_characteristics
      required_characteristics + optional_characteristics
    end

    def method_missing(name, *args)
      stringy_name = name.to_s

      if stringy_name[-1] == '='
        available_characteristics
          .find {|characteristic| characteristic.name == stringy_name.chop.to_sym}
          .value = args[0]
      else
        available_characteristics
          .find {|characteristic| characteristic.name == stringy_name.to_sym}
          .value
      end
    end

    def save
      IdentifierCache.add_accessory(accessory)
      IdentifierCache.add_service(self)

      required_characteristics.each do |characteristic|
        if characteristic.valid?
          IdentifierCache.add_characteristic(characteristic)
        end
      end

      optional_characteristics.each do |characteristic|
        if characteristic.user_defined?
          IdentifierCache.add_characteristic(characteristic)
        end
      end
    end
  end
end
