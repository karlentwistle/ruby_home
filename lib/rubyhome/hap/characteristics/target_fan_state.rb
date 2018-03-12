# This is an automatically generated file, please do not modify

module Rubyhome
  class Characteristic
    class TargetFanState < Characteristic
      def constraints
        {"ValidValues"=>{"0"=>"Manual", "1"=>"Auto"}}
      end

      def format
        "uint8"
      end

      def description
        "Target Fan State"
      end

      def permissions
        ["securedRead", "securedWrite"]
      end

      def properties
        ["read", "write", "cnotify"]
      end

      def uuid
        "000000BF-0000-1000-8000-0026BB765291"
      end

      def unit
        nil
      end
    end
  end
end
