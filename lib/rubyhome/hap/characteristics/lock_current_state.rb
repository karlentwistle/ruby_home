# This is an automatically generated file, please do not modify

module Rubyhome
  class Characteristic
    class LockCurrentState < Characteristic
      def constraints
        {"ValidValues"=>{"0"=>"Unsecured", "1"=>"Secured", "2"=>"Jammed", "3"=>"Unknown"}}
      end

      def format
        "uint8"
      end

      def description
        "Lock Current State"
      end

      def permissions
        ["securedRead"]
      end

      def properties
        ["read", "cnotify", "uncnotify"]
      end

      def uuid
        "0000001D-0000-1000-8000-0026BB765291"
      end

      def unit
        nil
      end
    end
  end
end
