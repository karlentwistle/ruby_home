# This is an automatically generated file, please do not modify

module Rubyhome
  class Characteristic
    class CurrentFanState < Characteristic
      def self.uuid
        "000000AF-0000-1000-8000-0026BB765291"
      end

      def self.name
        :current_fan_state
      end

      def self.format
        "uint8"
      end

      def constraints
        {"ValidValues"=>{"0"=>"Inactive", "1"=>"Idle", "2"=>"Blowing Air"}}
      end

      def description
        "Current Fan State"
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
