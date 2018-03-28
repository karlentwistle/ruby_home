# This is an automatically generated file, please do not modify

module Rubyhome
  class Characteristic
    class StatusLowBattery < Characteristic
      def self.uuid
        "00000079-0000-1000-8000-0026BB765291"
      end

      def self.name
        :status_low_battery
      end

      def self.format
        "uint8"
      end

      def constraints
        {"ValidValues"=>{"0"=>"Battery Level Normal", "1"=>"Battery Level Low"}}
      end

      def description
        "Status Low Battery"
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
