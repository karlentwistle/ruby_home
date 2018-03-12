# This is an automatically generated file, please do not modify

module Rubyhome
  class Characteristic
    class CurrentSlatState < Characteristic
      def constraints
        {"ValidValues"=>{"0"=>"Fixed", "1"=>"Jammed", "2"=>"Swinging"}}
      end

      def format
        "uint8"
      end

      def description
        "Current Slat State"
      end

      def permissions
        ["securedRead"]
      end

      def properties
        ["read", "cnotify"]
      end

      def uuid
        "000000AA-0000-1000-8000-0026BB765291"
      end

      def unit
        nil
      end
    end
  end
end
