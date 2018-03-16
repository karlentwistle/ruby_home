# This is an automatically generated file, please do not modify

module Rubyhome
  class Characteristic
    class ImageMirroring < Characteristic
      def self.uuid
        "0000011F-0000-1000-8000-0026BB765291"
      end

      def self.attribute_name
        :image_mirroring
      end

      def constraints
        {}
      end

      def format
        "bool"
      end

      def description
        "Image Mirroring"
      end

      def permissions
        ["securedRead", "securedWrite"]
      end

      def properties
        ["read", "write", "cnotify"]
      end

      def unit
        nil
      end
    end
  end
end
