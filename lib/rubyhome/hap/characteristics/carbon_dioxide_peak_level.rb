# This is an automatically generated file, please do not modify

module Rubyhome
  class Characteristic
    class CarbonDioxidePeakLevel < Characteristic
      def self.uuid
        "00000094-0000-1000-8000-0026BB765291"
      end

      def self.name
        :carbon_dioxide_peak_level
      end

      def constraints
        {"MaximumValue"=>100000, "MinimumValue"=>0}
      end

      def format
        "float"
      end

      def description
        "Carbon Dioxide Peak Level"
      end

      def permissions
        ["securedRead"]
      end

      def properties
        ["read", "cnotify"]
      end

      def unit
        nil
      end
    end
  end
end
