# This is an automatically generated file, please do not modify

module Rubyhome
  class Characteristic
    class PairVerify < Characteristic
      def self.uuid
        "0000004E-0000-1000-8000-0026BB765291"
      end

      def self.attribute_name
        :pair_verify
      end

      def constraints
        {}
      end

      def format
        "tlv8"
      end

      def description
        "Pair Verify"
      end

      def permissions
        ["read", "write"]
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
