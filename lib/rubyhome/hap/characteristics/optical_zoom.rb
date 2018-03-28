# This is an automatically generated file, please do not modify

module Rubyhome
  class Characteristic
    class OpticalZoom < Characteristic
      def self.uuid
        "0000011C-0000-1000-8000-0026BB765291"
      end

      def self.name
        :optical_zoom
      end

      def self.format
        "float"
      end

      def constraints
        {}
      end

      def description
        "Optical Zoom"
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
