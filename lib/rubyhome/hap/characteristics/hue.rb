# This is an automatically generated file, please do not modify

module Rubyhome
  class Characteristic
    class Hue < Characteristic
      def self.uuid
        "00000013-0000-1000-8000-0026BB765291"
      end

      def self.attribute_name
        :hue
      end

      def constraints
        {"MaximumValue"=>360, "MinimumValue"=>0, "StepValue"=>1}
      end

      def format
        "float"
      end

      def description
        "Hue"
      end

      def permissions
        ["securedRead", "securedWrite"]
      end

      def properties
        ["read", "write", "cnotify"]
      end

      def unit
        "arcdegrees"
      end
    end
  end
end
