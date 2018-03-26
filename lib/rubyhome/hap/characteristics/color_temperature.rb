# This is an automatically generated file, please do not modify

module Rubyhome
  class Characteristic
    class ColorTemperature < Characteristic
      def self.uuid
        "000000CE-0000-1000-8000-0026BB765291"
      end

      def self.name
        :color_temperature
      end

      def constraints
        {"MaximumValue"=>500, "MinimumValue"=>140, "StepValue"=>1}
      end

      def format
        "uint32"
      end

      def description
        "Color Temperature"
      end

      def permissions
        ["securedRead", "securedWrite"]
      end

      def properties
        ["read", "write", "cnotify"]
      end

      def unit
        nil
      end
    end
  end
end
