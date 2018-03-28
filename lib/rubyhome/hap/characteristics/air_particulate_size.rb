# This is an automatically generated file, please do not modify

module Rubyhome
  class Characteristic
    class AirParticulateSize < Characteristic
      def self.uuid
        "00000065-0000-1000-8000-0026BB765291"
      end

      def self.name
        :air_particulate_size
      end

      def self.format
        "uint8"
      end

      def constraints
        {"ValidValues"=>{"0"=>"2.5 μm", "1"=>"10 μm"}}
      end

      def description
        "Air Particulate Size"
      end

      def permissions
        ["securedRead"]
      end

      def properties
        ["read", "cnotify"]
      end

      def unit
        nil
      end
    end
  end
end
