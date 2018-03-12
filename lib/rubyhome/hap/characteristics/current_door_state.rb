# This is an automatically generated file, please do not modify

module Rubyhome
  class Characteristic
    class CurrentDoorState < Characteristic
      def constraints
        {"ValidValues"=>{"0"=>"Open", "1"=>"Closed", "2"=>"Opening", "3"=>"Closing", "4"=>"Stopped"}}
      end

      def format
        "uint8"
      end

      def description
        "Current Door State"
      end

      def permissions
        ["securedRead"]
      end

      def properties
        ["read", "cnotify", "uncnotify"]
      end

      def uuid
        "0000000E-0000-1000-8000-0026BB765291"
      end

      def unit
        nil
      end
    end
  end
end
