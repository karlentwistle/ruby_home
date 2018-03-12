# This is an automatically generated file, please do not modify

module Rubyhome
  class Characteristic
    class LeakDetected < Characteristic
      def constraints
        {"ValidValues"=>{"0"=>"Leak Not Detected", "1"=>"Leak Detected"}}
      end

      def format
        "uint8"
      end

      def description
        "Leak Detected"
      end

      def permissions
        ["securedRead"]
      end

      def properties
        ["read", "cnotify", "uncnotify"]
      end

      def uuid
        "00000070-0000-1000-8000-0026BB765291"
      end

      def unit
        nil
      end
    end
  end
end
