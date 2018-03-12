# This is an automatically generated file, please do not modify

module Rubyhome
  class Characteristic
    class TargetHeaterCoolerState < Characteristic
      def constraints
        {"ValidValues"=>{"0"=>"Auto", "1"=>"Heat", "2"=>"Cool"}}
      end

      def format
        "uint8"
      end

      def description
        "Target Heater Cooler State"
      end

      def permissions
        ["securedRead", "securedWrite"]
      end

      def properties
        ["read", "write", "cnotify"]
      end

      def uuid
        "000000B2-0000-1000-8000-0026BB765291"
      end

      def unit
        nil
      end
    end
  end
end
