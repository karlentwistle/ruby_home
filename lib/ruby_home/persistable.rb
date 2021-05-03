require "facets/cattr"

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
        File.open(source, "w") do |file|
          file.write(collection.to_yaml)
        end
      rescue Errno::EBADF
        false
      end

      def read
        return false unless File.exist?(source)

        YAML.load_file(source)
      rescue Errno::EBADF
        false
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
