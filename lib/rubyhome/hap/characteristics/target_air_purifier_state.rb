# This is an automatically generated file, please do not modify

module Rubyhome
  class Characteristic
    class TargetAirPurifierState < Characteristic
      def constraints
        {"ValidValues"=>{"0"=>"Manual", "1"=>"Auto"}}
      end

      def format
        "uint8"
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

      def uuid
        "000000A8-0000-1000-8000-0026BB765291"
      end

      def unit
        nil
      end
    end
  end
end
