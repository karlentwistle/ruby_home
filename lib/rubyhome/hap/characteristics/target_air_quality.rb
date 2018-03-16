# This is an automatically generated file, please do not modify

module Rubyhome
  class Characteristic
    class TargetAirQuality < Characteristic
      def self.uuid
        "000000AE-0000-1000-8000-0026BB765291"
      end

      def self.attribute_name
        :target_air_quality
      end

      def constraints
        {"ValidValues"=>{"0"=>"Excellent", "1"=>"Good", "2"=>"Fair"}}
      end

      def format
        "uint8"
      end

      def description
        "Target Air Quality"
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
