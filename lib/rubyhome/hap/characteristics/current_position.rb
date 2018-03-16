# This is an automatically generated file, please do not modify

module Rubyhome
  class Characteristic
    class CurrentPosition < Characteristic
      def self.uuid
        "0000006D-0000-1000-8000-0026BB765291"
      end

      def self.attribute_name
        :current_position
      end

      def constraints
        {"MaximumValue"=>100, "MinimumValue"=>0, "StepValue"=>1}
      end

      def format
        "uint8"
      end

      def description
        "Current Position"
      end

      def permissions
        ["securedRead"]
      end

      def properties
        ["read", "cnotify"]
      end

      def unit
        "percentage"
      end
    end
  end
end
