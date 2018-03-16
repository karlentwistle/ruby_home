# This is an automatically generated file, please do not modify

module Rubyhome
  class Characteristic
    class CurrentAmbientLightLevel < Characteristic
      def self.uuid
        "0000006B-0000-1000-8000-0026BB765291"
      end

      def self.attribute_name
        :current_ambient_light_level
      end

      def constraints
        {"MaximumValue"=>100000, "MinimumValue"=>0.0001}
      end

      def format
        "float"
      end

      def description
        "Current Ambient Light Level"
      end

      def permissions
        ["securedRead"]
      end

      def properties
        ["read", "cnotify"]
      end

      def unit
        "lux"
      end
    end
  end
end
