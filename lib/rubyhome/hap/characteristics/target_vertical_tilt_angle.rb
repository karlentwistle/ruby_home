# This is an automatically generated file, please do not modify

module Rubyhome
  class Characteristic
    class TargetVerticalTiltAngle < Characteristic
      def constraints
        {"MaximumValue"=>90, "MinimumValue"=>-90, "StepValue"=>1}
      end

      def format
        "int32"
      end

      def description
        "Target Vertical Tilt Angle"
      end

      def permissions
        ["securedRead", "securedWrite"]
      end

      def properties
        ["read", "write", "cnotify"]
      end

      def uuid
        "0000007D-0000-1000-8000-0026BB765291"
      end

      def unit
        "arcdegrees"
      end
    end
  end
end
