module RubyHome
  class IdentifierCache
    class << self
      attr_accessor :accessories

      def accessories
        @@accessories ||= []
      end

      def reset!
        @@accessories = []
      end

      def services
        accessories.flat_map(&:services)
      end

      def characteristics
        services.flat_map(&:characteristics)
      end

      def find_characteristics(attributes)
        characteristics.select do |characteristic|
          attributes.all? do |key, value|
            characteristic.send(key) == value
          end
        end
      end

      def add_accessory(accessory)
        return true if accessories.include?(accessory)

        accessories << accessory.tap do |a|
          a.id = accessories.size + 1
        end

      end

      def add_service(service)
        return true if services.include?(service)

        accessory = service.accessory
        accessory.services << service.tap do |s|
          s.instance_id = accessory.next_available_instance_id
        end

      end

      def add_characteristic(characteristic)
        return true if characteristics.include?(characteristic)

        service = characteristic.service
        service.characteristics << characteristic.tap do |c|
          c.instance_id = characteristic.accessory.next_available_instance_id
        end
      end
    end
  end
end
