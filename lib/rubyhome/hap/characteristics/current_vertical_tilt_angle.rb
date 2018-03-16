# This is an automatically generated file, please do not modify

module Rubyhome
  class Characteristic
    class CurrentVerticalTiltAngle < Characteristic
      def self.uuid
        "0000006E-0000-1000-8000-0026BB765291"
      end

      def self.attribute_name
        :current_vertical_tilt_angle
      end

      def constraints
        {"MaximumValue"=>90, "MinimumValue"=>-90, "StepValue"=>1}
      end

      def format
        "int32"
      end

      def description
        "Current Vertical Tilt Angle"
      end

      def permissions
        ["securedRead"]
      end

      def properties
        ["read", "cnotify"]
      end

      def unit
        "arcdegrees"
      end
    end
  end
end
