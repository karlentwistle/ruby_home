# This is an automatically generated file, please do not modify

module Rubyhome
  class Characteristic
    class CurrentRelativeHumidity < Characteristic
      def self.uuid
        "00000010-0000-1000-8000-0026BB765291"
      end

      def self.name
        :current_relative_humidity
      end

      def self.format
        "float"
      end

      def constraints
        {"MaximumValue"=>100, "MinimumValue"=>0, "StepValue"=>1}
      end

      def description
        "Current Relative Humidity"
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
