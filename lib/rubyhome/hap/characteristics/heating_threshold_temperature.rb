# This is an automatically generated file, please do not modify

module Rubyhome
  class Characteristic
    class HeatingThresholdTemperature < Characteristic
      def constraints
        {"MaximumValue"=>25, "MinimumValue"=>0, "StepValue"=>0.1}
      end

      def format
        "float"
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

      def uuid
        "00000012-0000-1000-8000-0026BB765291"
      end

      def unit
        "celsius"
      end
    end
  end
end
