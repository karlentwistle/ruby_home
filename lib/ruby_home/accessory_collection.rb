module RubyHome
  class AccessoryCollection
    include Enumerable
    attr_accessor :accessories

    def initialize(*accessories)
      @accessories = accessories
    end

    def each(&block)
      accessories.each(&block)
    end

    def <<(accessory)
      @accessories << accessory
    end

    def find_characteristic(attributes)
      characteristics.find do |characteristic|
        attributes.all? do |key, value|
          characteristic.send(key) == value
        end
      end
    end

    private

      def services
        accessories.flat_map(&:services)
      end

      def characteristics
        services.flat_map(&:characteristics)
      end
  end
end
