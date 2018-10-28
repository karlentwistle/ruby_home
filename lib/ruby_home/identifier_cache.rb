module RubyHome
  class IdentifierCache
    include Persistable

    self.source = 'identifier_cache.yml'

    def self.instance
      @@_instance ||= persisted || create
    end

    def self.reload
      @@_instance = nil
    end

    def initialize(accessory_id: , instance_id: , uuid: )
      @accessory_id = accessory_id
      @instance_id = instance_id
      @uuid = uuid
    end

    def persisted_attributes
      {
        accessory_id: accessory.id,
        instance_id: instance.instance_id,
        uuid: instance.uuid
      }
    end
  end
end

