# This is an automatically generated file, please do not modify

module Rubyhome
  class Characteristic
    class CurrentTemperature < Characteristic
      def self.uuid
        "00000011-0000-1000-8000-0026BB765291"
      end

      def self.name
        :current_temperature
      end

      def constraints
        {"MaximumValue"=>100, "MinimumValue"=>0, "StepValue"=>0.1}
      end

      def format
        "float"
      end

      def description
        "Current Temperature"
      end

      def permissions
        ["securedRead"]
      end

      def properties
        ["read", "cnotify"]
      end

      def unit
        "celsius"
      end
    end
  end
end
