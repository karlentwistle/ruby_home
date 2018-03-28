# This is an automatically generated file, please do not modify

module Rubyhome
  class Characteristic
    class TargetAirPurifierState < Characteristic
      def self.uuid
        "000000A8-0000-1000-8000-0026BB765291"
      end

      def self.name
        :target_air_purifier_state
      end

      def self.format
        "uint8"
      end

      def constraints
        {"ValidValues"=>{"0"=>"Manual", "1"=>"Auto"}}
      end

      def description
        "Target Air Purifier State"
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
