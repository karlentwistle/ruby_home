# This is an automatically generated file, please do not modify

module Rubyhome
  class Characteristic
    class RelativeHumidityHumidifierThreshold < Characteristic
      def self.uuid
        "000000CA-0000-1000-8000-0026BB765291"
      end

      def self.attribute_name
        :relative_humidity_humidifier_threshold
      end

      def constraints
        {"MaximumValue"=>100, "MinimumValue"=>0, "StepValue"=>1}
      end

      def format
        "float"
      end

      def description
        "Relative Humidity Humidifier Threshold"
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
