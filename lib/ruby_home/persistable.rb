require "facets/cattr"

module RubyHome
  module Persistable
    def self.included(base)
      base.send(:cattr_accessor, :source)
      base.send(:cattr_accessor, :cache)
      base.extend(ClassMethods)
    end

    module ClassMethods
      def persisted
        if (yaml = read)
          new(**yaml)
        end
      end

      def create(**options)
        new(**options).tap(&:save)
      end

      def write(collection)
        if cache != collection
          self.cache = collection
          persist
        end

        true
      end

      def persist
        File.write(source, cache.to_yaml)
      end

      def read_persisted
        YAML.load_file(source)
      end

      def read
        self.cache ||= read_persisted
      end

      def reset
        self.cache = nil
        persist
      end
    end

    def reload
      self.class.reload
    end

    def save
      self.class.write(persisted_attributes)
    end
  end
end
