# This is an automatically generated file, please do not modify

module Rubyhome
  class Characteristic
    class AirQuality < Characteristic
      def self.uuid
        "00000095-0000-1000-8000-0026BB765291"
      end

      def self.attribute_name
        :air_quality
      end

      def constraints
        {"ValidValues"=>{"0"=>"Unknown", "1"=>"Excellent", "2"=>"Good", "3"=>"Fair", "4"=>"Inferior", "5"=>"Poor"}}
      end

      def format
        "uint8"
      end

      def description
        "Air Quality"
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
