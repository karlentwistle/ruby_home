# This is an automatically generated file, please do not modify

module Rubyhome
  class Characteristic
    class ChargingState < Characteristic
      def self.uuid
        "0000008F-0000-1000-8000-0026BB765291"
      end

      def self.name
        :charging_state
      end

      def constraints
        {"ValidValues"=>{"0"=>"Not Charging", "1"=>"Charging", "2"=>"Not Chargeable"}}
      end

      def format
        "uint8"
      end

      def description
        "Charging State"
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
