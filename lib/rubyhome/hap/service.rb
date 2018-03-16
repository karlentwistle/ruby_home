Dir[File.dirname(__FILE__) + '/services/*.rb'].each { |file| require file }

module Rubyhome
  class Service
    def self.descendants
      ObjectSpace.each_object(Class).select { |klass| klass < self }
    end

    def initialize(accessory: , primary: false, hidden: false)
      @accessory = accessory
      @primary = primary
      @hidden = hidden
      @characteristics = []
    end

    attr_reader :accessory, :characteristics, :primary, :hidden
    attr_accessor :instance_id

    def uuid
      self.class.uuid
    end
  end
end
