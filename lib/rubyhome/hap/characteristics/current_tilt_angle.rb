# This is an automatically generated file, please do not modify

module Rubyhome
  class Characteristic
    class CurrentTiltAngle < Characteristic
      def self.uuid
        "000000C1-0000-1000-8000-0026BB765291"
      end

      def self.name
        :current_tilt_angle
      end

      def constraints
        {"MaximumValue"=>90, "MinimumValue"=>-90, "StepValue"=>1}
      end

      def format
        "int32"
      end

      def description
        "Current Tilt Angle"
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
