# This is an automatically generated file, please do not modify

module Rubyhome
  class Characteristic
    class StatusFault < Characteristic
      def constraints
        {"ValidValues"=>{"0"=>"No Fault", "1"=>"General Fault"}}
      end

      def format
        "uint8"
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

      def uuid
        "00000077-0000-1000-8000-0026BB765291"
      end

      def unit
        nil
      end
    end
  end
end
