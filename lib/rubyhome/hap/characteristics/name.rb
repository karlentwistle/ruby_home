# This is an automatically generated file, please do not modify

module Rubyhome
  class Characteristic
    class Name < Characteristic
      def self.uuid
        "00000023-0000-1000-8000-0026BB765291"
      end

      def self.name
        :name
      end

      def self.format
        "string"
      end

      def constraints
        {}
      end

      def description
        "Name"
      end

      def permissions
        ["securedRead"]
      end

      def properties
        ["read"]
      end

      def unit
        nil
      end
    end
  end
end
