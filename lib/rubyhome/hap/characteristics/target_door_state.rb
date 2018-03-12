# This is an automatically generated file, please do not modify

module Rubyhome
  class Characteristic
    class TargetDoorState < Characteristic
      def constraints
        {"ValidValues"=>{"0"=>"Open", "1"=>"Closed"}}
      end

      def format
        "uint8"
      end

      def description
        "Target Door State"
      end

      def permissions
        ["securedRead", "securedWrite"]
      end

      def properties
        ["read", "write", "cnotify"]
      end

      def uuid
        "00000032-0000-1000-8000-0026BB765291"
      end

      def unit
        nil
      end
    end
  end
end
