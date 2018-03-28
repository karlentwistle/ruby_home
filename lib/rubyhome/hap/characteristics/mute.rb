# This is an automatically generated file, please do not modify

module Rubyhome
  class Characteristic
    class Mute < Characteristic
      def self.uuid
        "0000011A-0000-1000-8000-0026BB765291"
      end

      def self.name
        :mute
      end

      def self.format
        "bool"
      end

      def constraints
        {}
      end

      def description
        "Mute"
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
