# This is an automatically generated file, please do not modify

module Rubyhome
  class Characteristic
    class Hue < Characteristic
      def self.uuid
        "00000013-0000-1000-8000-0026BB765291"
      end

      def self.name
        :hue
      end

      def self.format
        "float"
      end

      def constraints
        {"MaximumValue"=>360, "MinimumValue"=>0, "StepValue"=>1}
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
