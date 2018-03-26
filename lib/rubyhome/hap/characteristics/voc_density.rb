# This is an automatically generated file, please do not modify

module Rubyhome
  class Characteristic
    class VOCDensity < Characteristic
      def self.uuid
        "000000C8-0000-1000-8000-0026BB765291"
      end

      def self.name
        :voc_density
      end

      def constraints
        {"MaximumValue"=>1000, "MinimumValue"=>0, "StepValue"=>1}
      end

      def format
        "float"
      end

      def description
        "VOC Density"
      end

      def permissions
        ["securedRead"]
      end

      def properties
        ["read", "cnotify", "uncnotify"]
      end

      def unit
        nil
      end
    end
  end
end
