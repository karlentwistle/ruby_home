# This is an automatically generated file, please do not modify

module Rubyhome
  class Characteristic
    class CurrentAirPurifierState < Characteristic
      def constraints
        {"ValidValues"=>{"0"=>"Inactive", "1"=>"Idle", "2"=>"Purifying Air"}}
      end

      def format
        "uint8"
      end

      def description
        "Current Air Purifier State"
      end

      def permissions
        ["securedRead"]
      end

      def properties
        ["read", "cnotify"]
      end

      def uuid
        "000000A9-0000-1000-8000-0026BB765291"
      end

      def unit
        nil
      end
    end
  end
end
