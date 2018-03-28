# This is an automatically generated file, please do not modify

module Rubyhome
  class Characteristic
    class SecuritySystemTargetState < Characteristic
      def self.uuid
        "00000067-0000-1000-8000-0026BB765291"
      end

      def self.name
        :security_system_target_state
      end

      def self.format
        "uint8"
      end

      def constraints
        {"ValidValues"=>{"0"=>"Stay Arm", "1"=>"Away Arm", "2"=>"Night Arm", "3"=>"Disarm"}}
      end

      def description
        "Security System Target State"
      end

      def permissions
        ["securedRead", "securedWrite"]
      end

      def properties
        ["read", "write", "cnotify"]
      end

      def unit
        nil
      end
    end
  end
end
