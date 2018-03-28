# This is an automatically generated file, please do not modify

module Rubyhome
  class Characteristic
    class StatusTampered < Characteristic
      def self.uuid
        "0000007A-0000-1000-8000-0026BB765291"
      end

      def self.name
        :status_tampered
      end

      def self.format
        "uint8"
      end

      def constraints
        {"ValidValues"=>{"0"=>"Not Tampered", "1"=>"Tampered"}}
      end

      def description
        "Status Tampered"
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
