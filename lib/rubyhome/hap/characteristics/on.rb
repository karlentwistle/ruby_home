# This is an automatically generated file, please do not modify

module Rubyhome
  class Characteristic
    class On < Characteristic
      def self.uuid
        "00000025-0000-1000-8000-0026BB765291"
      end

      def self.name
        :on
      end

      def self.format
        "bool"
      end

      def constraints
        {}
      end

      def description
        "On"
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
