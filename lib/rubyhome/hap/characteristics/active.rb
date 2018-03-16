# This is an automatically generated file, please do not modify

module Rubyhome
  class Characteristic
    class Active < Characteristic
      def self.uuid
        "000000B0-0000-1000-8000-0026BB765291"
      end

      def self.attribute_name
        :active
      end

      def constraints
        {"ValidValues"=>{"0"=>"Inactive", "1"=>"Active"}}
      end

      def format
        "uint8"
      end

      def description
        "Active"
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
