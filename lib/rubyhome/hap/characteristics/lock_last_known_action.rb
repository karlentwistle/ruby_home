# This is an automatically generated file, please do not modify

module Rubyhome
  class Characteristic
    class LockLastKnownAction < Characteristic
      def self.uuid
        "0000001C-0000-1000-8000-0026BB765291"
      end

      def self.name
        :lock_last_known_action
      end

      def constraints
        {"ValidValues"=>{"0"=>"Secured Physically, Interior", "1"=>"Unsecured Physically, Interior", "2"=>"Secured Physically, Exterior", "3"=>"Unsecured Physically, Exterior", "4"=>"Secured by Keypad", "5"=>"Unsecured by Keypad", "6"=>"Secured Remotely", "7"=>"Unsecured Remotely", "8"=>"Secured by Auto Secure Timeout"}}
      end

      def format
        "uint8"
      end

      def description
        "Lock Last Known Action"
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
