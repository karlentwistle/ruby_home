# This is an automatically generated file, please do not modify

module Rubyhome
  class Characteristic
    class LockManagementAutoSecurityTimeout < Characteristic
      def constraints
        {}
      end

      def format
        "uint32"
      end

      def description
        "Lock Management Auto Security Timeout"
      end

      def permissions
        ["securedRead", "securedWrite"]
      end

      def properties
        ["read", "write", "cnotify"]
      end

      def uuid
        "0000001A-0000-1000-8000-0026BB765291"
      end

      def unit
        "seconds"
      end
    end
  end
end
