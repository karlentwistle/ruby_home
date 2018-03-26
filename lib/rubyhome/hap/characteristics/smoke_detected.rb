# This is an automatically generated file, please do not modify

module Rubyhome
  class Characteristic
    class SmokeDetected < Characteristic
      def self.uuid
        "00000076-0000-1000-8000-0026BB765291"
      end

      def self.name
        :smoke_detected
      end

      def constraints
        {"ValidValues"=>{"0"=>"Smoke Not Detected", "1"=>"Smoke Detected"}}
      end

      def format
        "uint8"
      end

      def description
        "Smoke Detected"
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
