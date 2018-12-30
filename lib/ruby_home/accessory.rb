require_relative 'accessory_collection'

module RubyHome
  class Accessory
    @@all = AccessoryCollection.new

    def self.all
      @@all
    end

    def self.reset
      @@all = AccessoryCollection.new
    end

    def initialize
      @services = ServiceCollection.new
      @id = next_available_accessory_id
      @@all << self
    end

    attr_reader :services, :id

    def characteristics
      services.characteristics
    end

    def next_available_instance_id
      (largest_instance_id || 0) + 1
    end

    def has_accessory_information?
      services.any? do |service|
        service.name == :accessory_information
      end
    end

    def contains_instance_id?(instance_id)
      services.any? do |service|
        service.contains_instance_id?(instance_id)
      end
    end

    private

    def largest_instance_id
      IdentifierCache.where(accessory_id: id).map(&:instance_id).max
    end

    def next_available_accessory_id
      self.class.all.count + 1
    end
  end
end
