# This is an automatically generated file, please do not modify

module Rubyhome
  class Characteristic
    class OccupancyDetected < Characteristic
      def self.uuid
        "00000071-0000-1000-8000-0026BB765291"
      end

      def self.attribute_name
        :occupancy_detected
      end

      def constraints
        {"ValidValues"=>{"0"=>"Occupancy Not Detected", "1"=>"Occupancy Detected"}}
      end

      def format
        "uint8"
      end

      def description
        "Occupancy Detected"
      end

      def permissions
        ["securedRead"]
      end

      def properties
        ["read", "cnotify", "uncnotify"]
      end

      def unit
        nil
      end
    end
  end
end
