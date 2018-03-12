# This is an automatically generated file, please do not modify

module Rubyhome
  class Characteristic
    class Brightness < Characteristic
      def constraints
        {"MaximumValue"=>100, "MinimumValue"=>0, "StepValue"=>1}
      end

      def format
        "int32"
      end

      def description
        "Brightness"
      end

      def permissions
        ["securedRead", "securedWrite"]
      end

      def properties
        ["read", "write", "cnotify"]
      end

      def uuid
        "00000008-0000-1000-8000-0026BB765291"
      end

      def unit
        "percentage"
      end
    end
  end
end
