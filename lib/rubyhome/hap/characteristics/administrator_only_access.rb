# This is an automatically generated file, please do not modify

module Rubyhome
  class Characteristic
    class AdministratorOnlyAccess < Characteristic
      def self.uuid
        "00000001-0000-1000-8000-0026BB765291"
      end

      def self.attribute_name
        :administrator_only_access
      end

      def constraints
        {}
      end

      def format
        "bool"
      end

      def description
        "Administrator Only Access"
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
