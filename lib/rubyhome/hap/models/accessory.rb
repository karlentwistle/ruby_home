module Rubyhome
  class Accessory
    def self.all(grouped_services = Service.grouped_by_accessory)
      grouped_services.inject(Array.new) do |array, (accessory_id, services)|
        array << new(id: accessory_id, services: services)
        array
      end
    end

    def initialize(id:, services: [])
      @id = id
      @services = services
    end

    attr_reader :id, :services
  end
end
