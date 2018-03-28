# This is an automatically generated file, please do not modify

module Rubyhome
  class Characteristic
    class AccessoryFlags < Characteristic
      def self.uuid
        "000000A6-0000-1000-8000-0026BB765291"
      end

      def self.name
        :accessory_flags
      end

      def self.format
        "uint32"
      end

      def constraints
        {"ValidBits"=>{"0"=>"Requires Additional Setup"}}
      end

      def description
        "Accessory Flags"
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
