module RubyHome
  module Persistable
    def self.included(base)
      base.extend(ClassMethods)
    end

    module ClassMethods
      def persisted
        new(read) if read
      end

      def create(**options)
        new(**options).tap(&:save)
      end

      def write(collection)
        File.open(source, 'w') {|f| f.write(collection.to_yaml) }
      end

      def read
        return false unless File.exists?(source)

        YAML.load_file(source)
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
