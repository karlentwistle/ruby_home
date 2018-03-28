# This is an automatically generated file, please do not modify

module Rubyhome
  class Characteristic
    class Model < Characteristic
      def self.uuid
        "00000021-0000-1000-8000-0026BB765291"
      end

      def self.name
        :model
      end

      def self.format
        "string"
      end

      def constraints
        {}
      end

      def description
        "Model"
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
