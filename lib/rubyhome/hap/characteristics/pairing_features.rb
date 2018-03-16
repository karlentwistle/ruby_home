# This is an automatically generated file, please do not modify

module Rubyhome
  class Characteristic
    class PairingFeatures < Characteristic
      def self.uuid
        "0000004F-0000-1000-8000-0026BB765291"
      end

      def self.attribute_name
        :pairing_features
      end

      def constraints
        {}
      end

      def format
        "uint8"
      end

      def description
        "Pairing Features"
      end

      def permissions
        ["read"]
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
