# This is an automatically generated file, please do not modify

module Rubyhome
  class Characteristic
    class LockTargetState < Characteristic
      def constraints
        {"ValidValues"=>{"0"=>"Unsecured", "1"=>"Secured"}}
      end

      def format
        "uint8"
      end

      def description
        "Lock Target State"
      end

      def permissions
        ["securedRead", "securedWrite"]
      end

      def properties
        ["read", "write", "cnotify", "uncnotify"]
      end

      def uuid
        "0000001E-0000-1000-8000-0026BB765291"
      end

      def unit
        nil
      end
    end
  end
end
