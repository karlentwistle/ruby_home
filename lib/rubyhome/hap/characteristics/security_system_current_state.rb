# This is an automatically generated file, please do not modify

module Rubyhome
  class Characteristic
    class SecuritySystemCurrentState < Characteristic
      def self.uuid
        "00000066-0000-1000-8000-0026BB765291"
      end

      def self.name
        :security_system_current_state
      end

      def self.format
        "uint8"
      end

      def constraints
        {"ValidValues"=>{"0"=>"Stay Arm", "1"=>"Away Arm", "2"=>"Night Arm", "3"=>"Disarmed", "4"=>"Alarm Triggered"}}
      end

      def description
        "Security System Current State"
      end

      def permissions
        ["securedRead"]
      end

      def properties
        ["read", "cnotify", "uncnotify"]
      end

      def unit
        nil
      end
    end
  end
end
