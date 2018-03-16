# This is an automatically generated file, please do not modify

module Rubyhome
  class Characteristic
    class TemperatureDisplayUnits < Characteristic
      def self.uuid
        "00000036-0000-1000-8000-0026BB765291"
      end

      def self.attribute_name
        :temperature_display_units
      end

      def constraints
        {"ValidValues"=>{"0"=>"Celsius", "1"=>"Fahrenheit"}}
      end

      def format
        "uint8"
      end

      def description
        "Temperature Display Units"
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
