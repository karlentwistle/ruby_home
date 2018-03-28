# This is an automatically generated file, please do not modify

module Rubyhome
  class Characteristic
    class StatusActive < Characteristic
      def self.uuid
        "00000075-0000-1000-8000-0026BB765291"
      end

      def self.name
        :status_active
      end

      def self.format
        "bool"
      end

      def constraints
        {}
      end

      def description
        "Status Active"
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
