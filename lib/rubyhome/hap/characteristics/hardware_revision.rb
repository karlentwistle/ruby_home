# This is an automatically generated file, please do not modify

module Rubyhome
  class Characteristic
    class HardwareRevision < Characteristic
      def self.uuid
        "00000053-0000-1000-8000-0026BB765291"
      end

      def self.attribute_name
        :hardware_revision
      end

      def constraints
        {}
      end

      def format
        "string"
      end

      def description
        "Hardware Revision"
      end

      def permissions
        ["securedRead"]
      end

      def properties
        ["read"]
      end

      def unit
        nil
      end
    end
  end
end
