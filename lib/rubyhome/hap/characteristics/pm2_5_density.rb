# This is an automatically generated file, please do not modify

module Rubyhome
  class Characteristic
    class PM2_5Density < Characteristic
      def constraints
        {"MaximumValue"=>1000, "MinimumValue"=>0, "StepValue"=>1}
      end

      def format
        "float"
      end

      def description
        "PM2.5 Density"
      end

      def permissions
        ["securedRead"]
      end

      def properties
        ["read", "cnotify", "uncnotify"]
      end

      def uuid
        "000000C6-0000-1000-8000-0026BB765291"
      end

      def unit
        nil
      end
    end
  end
end
