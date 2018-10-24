module RubyHome
  module Persistable
    def self.included(base)
      base.extend(ClassMethods)
    end

    module ClassMethods
      def instance
        persisted || create
      end

      def persisted
        new(read) if read
      end

      def create
        new.save
      end

      def source(file=nil)
        file ? @file = (file.to_s) : @file
      end

      def write(collection)
        File.open(source, 'w') {|f| f.write(collection.to_yaml) }
      end

      def read
        return false unless File.exists?(source)

        YAML.load_file(source)
      end
    end

    def save
      self.class.write(persisted_attributes)

      return self
    end
  end
end
