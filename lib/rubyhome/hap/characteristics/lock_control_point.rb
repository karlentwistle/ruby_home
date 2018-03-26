# This is an automatically generated file, please do not modify

module Rubyhome
  class Characteristic
    class LockControlPoint < Characteristic
      def self.uuid
        "00000019-0000-1000-8000-0026BB765291"
      end

      def self.name
        :lock_control_point
      end

      def constraints
        {}
      end

      def format
        "tlv8"
      end

      def description
        "Lock Control Point"
      end

      def permissions
        ["securedWrite"]
      end

      def properties
        ["write"]
      end

      def unit
        nil
      end
    end
  end
end
