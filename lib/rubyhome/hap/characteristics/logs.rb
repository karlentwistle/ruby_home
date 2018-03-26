# This is an automatically generated file, please do not modify

module Rubyhome
  class Characteristic
    class Logs < Characteristic
      def self.uuid
        "0000001F-0000-1000-8000-0026BB765291"
      end

      def self.name
        :logs
      end

      def constraints
        {}
      end

      def format
        "tlv8"
      end

      def description
        "Logs"
      end

      def permissions
        ["securedRead"]
      end

      def properties
        ["read", "cnotify"]
      end

      def unit
        nil
      end
    end
  end
end
