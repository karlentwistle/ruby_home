# This is an automatically generated file, please do not modify

module Rubyhome
  class Characteristic
    class TargetRelativeHumidity < Characteristic
      def self.uuid
        "00000034-0000-1000-8000-0026BB765291"
      end

      def self.attribute_name
        :target_relative_humidity
      end

      def constraints
        {"MaximumValue"=>100, "MinimumValue"=>0, "StepValue"=>1}
      end

      def format
        "float"
      end

      def description
        "Target Relative Humidity"
      end

      def permissions
        ["securedRead", "securedWrite"]
      end

      def properties
        ["read", "write", "cnotify"]
      end

      def unit
        "percentage"
      end
    end
  end
end
