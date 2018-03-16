# This is an automatically generated file, please do not modify

module Rubyhome
  class Characteristic
    class HoldPosition < Characteristic
      def self.uuid
        "0000006F-0000-1000-8000-0026BB765291"
      end

      def self.attribute_name
        :hold_position
      end

      def constraints
        {}
      end

      def format
        "bool"
      end

      def description
        "Hold Position"
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
