# This is an automatically generated file, please do not modify

module Rubyhome
  class Characteristic
    class NightVision < Characteristic
      def self.uuid
        "0000011B-0000-1000-8000-0026BB765291"
      end

      def self.name
        :night_vision
      end

      def self.format
        "bool"
      end

      def constraints
        {}
      end

      def description
        "Night Vision"
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
