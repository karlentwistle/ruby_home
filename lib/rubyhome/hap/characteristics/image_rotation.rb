# This is an automatically generated file, please do not modify

module Rubyhome
  class Characteristic
    class ImageRotation < Characteristic
      def self.uuid
        "0000011E-0000-1000-8000-0026BB765291"
      end

      def self.attribute_name
        :image_rotation
      end

      def constraints
        {"MaximumValue"=>270, "MinimumValue"=>0, "StepValue"=>90}
      end

      def format
        "float"
      end

      def description
        "Image Rotation"
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
