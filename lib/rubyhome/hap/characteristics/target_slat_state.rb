# This is an automatically generated file, please do not modify

module Rubyhome
  class Characteristic
    class TargetSlatState < Characteristic
      def self.uuid
        "000000BE-0000-1000-8000-0026BB765291"
      end

      def self.name
        :target_slat_state
      end

      def constraints
        {"ValidValues"=>{"0"=>"Manual", "1"=>"Auto"}}
      end

      def format
        "uint8"
      end

      def description
        "Target Slat State"
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
