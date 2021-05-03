require_relative "persistable"

module RubyHome
  class IdentifierCache
    include Persistable

    self.source = "identifier_cache.yml"

    def self.all
      raw_items = read || []
      raw_items.map do |raw_item|
        new(**raw_item)
      end
    end

    def self.create(**attributes)
      new(**attributes).save
    end

    def self.find_by(**attributes)
      all.find do |identifier_cache|
        attributes.all? do |key, value|
          identifier_cache.send(key) == value
        end
      end
    end

    def self.where(**attributes)
      all.select do |identifier_cache|
        attributes.all? do |key, value|
          identifier_cache.send(key) == value
        end
      end
    end

    def initialize(accessory_id:, instance_id:, subtype:, uuid:, service_uuid: nil)
      @accessory_id = accessory_id
      @instance_id = instance_id
      @subtype = subtype
      @service_uuid = service_uuid
      @uuid = uuid
    end

    attr_reader :accessory_id, :instance_id, :service_uuid, :subtype, :uuid

    def persisted_attributes
      existing_items = self.class.all
      existing_items << self
      existing_items.map do |identifier|
        {
          accessory_id: identifier.accessory_id,
          instance_id: identifier.instance_id,
          subtype: identifier.subtype,
          service_uuid: identifier.service_uuid,
          uuid: identifier.uuid
        }
      end
    end
  end
end
