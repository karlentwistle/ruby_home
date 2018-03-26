# This is an automatically generated file, please do not modify

module Rubyhome
  class Characteristic
    class LockPhysicalControls < Characteristic
      def self.uuid
        "000000A7-0000-1000-8000-0026BB765291"
      end

      def self.name
        :lock_physical_controls
      end

      def constraints
        {"ValidValues"=>{"0"=>"Control Lock Disabled", "1"=>"Control Lock Enabled"}}
      end

      def format
        "uint8"
      end

      def description
        "Lock Physical Controls"
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
