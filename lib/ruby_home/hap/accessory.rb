module RubyHome
  class Accessory
    def initialize
      @services = []
    end

    attr_accessor :id
    attr_reader :services

    def characteristics
      services.flat_map(&:characteristics)
    end

    def next_available_instance_id
      (largest_instance_id || 0) + 1
    end

    def instance_ids
      services.map(&:instance_id) + characteristics.map(&:instance_id)
    end

    def largest_instance_id
      instance_ids.max
    end
  end
end
