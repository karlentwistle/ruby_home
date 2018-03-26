# This is an automatically generated file, please do not modify

module Rubyhome
  class Characteristic
    class PairingPairings < Characteristic
      def self.uuid
        "00000050-0000-1000-8000-0026BB765291"
      end

      def self.name
        :pairing_pairings
      end

      def constraints
        {}
      end

      def format
        "tlv8"
      end

      def description
        "Pairing Pairings"
      end

      def permissions
        ["securedRead", "securedWrite"]
      end

      def properties
        ["read", "write"]
      end

      def unit
        nil
      end
    end
  end
end
