# This is an automatically generated file, please do not modify

module Rubyhome
  class Characteristic
    class NitrogenDioxideDensity < Characteristic
      def constraints
        {"MaximumValue"=>1000, "MinimumValue"=>0, "StepValue"=>1}
      end

      def format
        "float"
      end

      def description
        "Nitrogen Dioxide Density"
      end

      def permissions
        ["securedRead"]
      end

      def properties
        ["read", "cnotify", "uncnotify"]
      end

      def uuid
        "000000C4-0000-1000-8000-0026BB765291"
      end

      def unit
        nil
      end
    end
  end
end
