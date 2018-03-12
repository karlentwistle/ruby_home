# This is an automatically generated file, please do not modify

module Rubyhome
  class Characteristic
    class OutletInUse < Characteristic
      def constraints
        {}
      end

      def format
        "bool"
      end

      def description
        "Outlet In Use"
      end

      def permissions
        ["securedRead"]
      end

      def properties
        ["read", "cnotify"]
      end

      def uuid
        "00000026-0000-1000-8000-0026BB765291"
      end

      def unit
        nil
      end
    end
  end
end
