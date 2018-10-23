module RubyHome
  class IdentifierCache < YamlRecord::Base
    properties :accessories
    source 'identifier_cache.yml'

    set_callback :before_create, :set_accessories

    def self.instance
      first || create
    end

    def services
      accessories.flat_map(&:services)
    end

    def characteristics
      services.flat_map(&:characteristics)
    end

    def find_characteristic(attributes)
      characteristics.find do |characteristic|
        attributes.all? do |key, value|
          characteristic.send(key) == value
        end
      end
    end

    def add_accessory(accessory, should_save: true)
      if existing_id = accessories.index { |a| a.id == accessory.id }
        accessories[existing_id] = accessory
      else
        accessory.id = next_available_accessory_id
        accessories << accessory
      end

      save if should_save

      accessory
    end

    def add_service(service, should_save: true)
      accessory = add_accessory(service.accessory, should_save: false)

      if existing_instance_id = accessory.services.index { |s| s.instance_id == service.instance_id }
        accessory.services[existing_instance_id] = service
      else
        service.instance_id = accessory.next_available_instance_id
        accessory.services << service
      end

      save if should_save

      service
    end

    def add_characteristic(characteristic, should_save: true)
      service = add_service(characteristic.service, should_save: false)

      if existing_instance_id = service.characteristics.index { |c| c.instance_id == characteristic.instance_id }
        service.characteristics[existing_instance_id] = characteristic
      else
        characteristic.instance_id = service.accessory.next_available_instance_id
        service.characteristics << characteristic
      end

      save if should_save

      characteristic
    end

    private

      def next_available_accessory_id
        accessories.size + 1
      end

      def set_accessories
        self.accessories = []
      end
  end
end
