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
      @services = []
      @id = next_available_accessory_id
      @@all << self
    end

    attr_reader :services, :id

    def characteristics
      services.flat_map(&:characteristics)
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
      instance_ids.include?(instance_id)
    end

    private

    def instance_ids
      instances.map(&:instance_id)
    end

    def instances
      services + characteristics
    end

    def largest_instance_id
      IdentifierCache.where(accessory_id: id).map(&:instance_id).max
    end

    def next_available_accessory_id
      self.class.all.count + 1
    end
  end
end
