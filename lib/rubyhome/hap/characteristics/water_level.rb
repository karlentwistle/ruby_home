# This is an automatically generated file, please do not modify

module Rubyhome
  class Characteristic
    class WaterLevel < Characteristic
      def self.uuid
        "000000B5-0000-1000-8000-0026BB765291"
      end

      def self.attribute_name
        :water_level
      end

      def constraints
        {"MaximumValue"=>100, "MinimumValue"=>0}
      end

      def format
        "float"
      end

      def description
        "Water Level"
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
