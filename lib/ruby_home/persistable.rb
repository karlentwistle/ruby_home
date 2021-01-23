require 'facets/cattr'

module RubyHome
  module Persistable
    def self.included(base)
      base.send(:cattr_accessor, :source)
      base.extend(ClassMethods)
    end

    module ClassMethods
      def persisted
        if yaml = read
          new(**yaml)
        end
      end

      def create(**options)
        new(**options).tap(&:save)
      end

      def write(collection)
        source.rewind
        source.write(collection.to_yaml)
      end

      def read
        source.rewind
        YAML.load(source.read)
      end

      def reload
        self.class_variable_set(:@@_instance, nil)
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
