# This is an automatically generated file, please do not modify

module Rubyhome
  class Characteristic
    class CoolingThresholdTemperature < Characteristic
      def self.uuid
        "0000000D-0000-1000-8000-0026BB765291"
      end

      def self.name
        :cooling_threshold_temperature
      end

      def constraints
        {"MaximumValue"=>35, "MinimumValue"=>10, "StepValue"=>0.1}
      end

      def format
        "float"
      end

      def description
        "Cooling Threshold Temperature"
      end

      def permissions
        ["securedRead", "securedWrite"]
      end

      def properties
        ["read", "write", "cnotify"]
      end

      def unit
        "celsius"
      end
    end
  end
end
