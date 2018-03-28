# This is an automatically generated file, please do not modify

module Rubyhome
  class Characteristic
    class DigitalZoom < Characteristic
      def self.uuid
        "0000011D-0000-1000-8000-0026BB765291"
      end

      def self.name
        :digital_zoom
      end

      def self.format
        "float"
      end

      def constraints
        {}
      end

      def description
        "Digital Zoom"
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
