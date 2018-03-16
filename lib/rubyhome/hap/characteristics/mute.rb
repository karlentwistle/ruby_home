# This is an automatically generated file, please do not modify

module Rubyhome
  class Characteristic
    class Mute < Characteristic
      def self.uuid
        "0000011A-0000-1000-8000-0026BB765291"
      end

      def self.attribute_name
        :mute
      end

      def constraints
        {}
      end

      def format
        "bool"
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