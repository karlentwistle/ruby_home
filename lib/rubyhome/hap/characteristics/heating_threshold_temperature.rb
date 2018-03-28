# This is an automatically generated file, please do not modify

module Rubyhome
  class Characteristic
    class HeatingThresholdTemperature < Characteristic
      def self.uuid
        "00000012-0000-1000-8000-0026BB765291"
      end

      def self.name
        :heating_threshold_temperature
      end

      def self.format
        "float"
      end

      def constraints
        {"MaximumValue"=>25, "MinimumValue"=>0, "StepValue"=>0.1}
      end

      def description
        "Heating Threshold Temperature"
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
