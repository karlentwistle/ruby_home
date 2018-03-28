# This is an automatically generated file, please do not modify

module Rubyhome
  class Characteristic
    class RelativeHumidityDehumidifierThreshold < Characteristic
      def self.uuid
        "000000C9-0000-1000-8000-0026BB765291"
      end

      def self.name
        :relative_humidity_dehumidifier_threshold
      end

      def self.format
        "float"
      end

      def constraints
        {"MaximumValue"=>100, "MinimumValue"=>0, "StepValue"=>1}
      end

      def description
        "Relative Humidity Dehumidifier Threshold"
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
