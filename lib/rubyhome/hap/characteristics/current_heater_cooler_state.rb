# This is an automatically generated file, please do not modify

module Rubyhome
  class Characteristic
    class CurrentHeaterCoolerState < Characteristic
      def constraints
        {"ValidValues"=>{"0"=>"Inactive", "1"=>"Idle", "2"=>"Heating", "3"=>"Cooling"}}
      end

      def format
        "uint8"
      end

      def description
        "Current Heater Cooler State"
      end

      def permissions
        ["securedRead"]
      end

      def properties
        ["read", "cnotify"]
      end

      def uuid
        "000000B1-0000-1000-8000-0026BB765291"
      end

      def unit
        nil
      end
    end
  end
end
