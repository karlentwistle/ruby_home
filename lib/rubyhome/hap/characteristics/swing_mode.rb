# This is an automatically generated file, please do not modify

module Rubyhome
  class Characteristic
    class SwingMode < Characteristic
      def self.uuid
        "000000B6-0000-1000-8000-0026BB765291"
      end

      def self.name
        :swing_mode
      end

      def self.format
        "uint8"
      end

      def constraints
        {"ValidValues"=>{"0"=>"Swing Disabled", "1"=>"Swing Enabled"}}
      end

      def description
        "Swing Mode"
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
