# This is an automatically generated file, please do not modify

module Rubyhome
  class Characteristic
    class FilterChangeIndication < Characteristic
      def constraints
        {"ValidValues"=>{"0"=>"Filter OK", "1"=>"Change Filter"}}
      end

      def format
        "uint8"
      end

      def description
        "Filter Change Indication"
      end

      def permissions
        ["securedRead"]
      end

      def properties
        ["read", "cnotify"]
      end

      def uuid
        "000000AC-0000-1000-8000-0026BB765291"
      end

      def unit
        nil
      end
    end
  end
end
