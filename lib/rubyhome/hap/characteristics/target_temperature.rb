# This is an automatically generated file, please do not modify

module Rubyhome
  class Characteristic
    class TargetTemperature < Characteristic
      def self.uuid
        "00000035-0000-1000-8000-0026BB765291"
      end

      def self.name
        :target_temperature
      end

      def self.format
        "float"
      end

      def constraints
        {"MaximumValue"=>38, "MinimumValue"=>10, "StepValue"=>0.1}
      end

      def description
        "Target Temperature"
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
