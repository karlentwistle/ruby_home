# This is an automatically generated file, please do not modify

module Rubyhome
  class Characteristic
    class Manufacturer < Characteristic
      def self.uuid
        "00000020-0000-1000-8000-0026BB765291"
      end

      def self.name
        :manufacturer
      end

      def constraints
        {}
      end

      def format
        "string"
      end

      def description
        "Manufacturer"
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
