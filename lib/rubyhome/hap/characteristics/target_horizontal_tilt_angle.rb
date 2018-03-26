# This is an automatically generated file, please do not modify

module Rubyhome
  class Characteristic
    class TargetHorizontalTiltAngle < Characteristic
      def self.uuid
        "0000007B-0000-1000-8000-0026BB765291"
      end

      def self.name
        :target_horizontal_tilt_angle
      end

      def constraints
        {"MaximumValue"=>90, "MinimumValue"=>-90, "StepValue"=>1}
      end

      def format
        "int32"
      end

      def description
        "Target Horizontal Tilt Angle"
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
