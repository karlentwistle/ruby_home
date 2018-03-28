# This is an automatically generated file, please do not modify

module Rubyhome
  class Characteristic
    class StatusFault < Characteristic
      def self.uuid
        "00000077-0000-1000-8000-0026BB765291"
      end

      def self.name
        :status_fault
      end

      def self.format
        "uint8"
      end

      def constraints
        {"ValidValues"=>{"0"=>"No Fault", "1"=>"General Fault"}}
      end

      def description
        "Status Fault"
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
