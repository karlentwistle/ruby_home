# This is an automatically generated file, please do not modify

module Rubyhome
  class Characteristic
    class BatteryLevel < Characteristic
      def self.uuid
        "00000068-0000-1000-8000-0026BB765291"
      end

      def self.name
        :battery_level
      end

      def self.format
        "uint8"
      end

      def constraints
        {"MaximumValue"=>100, "MinimumValue"=>0, "StepValue"=>1}
      end

      def description
        "Battery Level"
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
