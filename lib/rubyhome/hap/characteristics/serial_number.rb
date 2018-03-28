# This is an automatically generated file, please do not modify

module Rubyhome
  class Characteristic
    class SerialNumber < Characteristic
      def self.uuid
        "00000030-0000-1000-8000-0026BB765291"
      end

      def self.name
        :serial_number
      end

      def self.format
        "string"
      end

      def constraints
        {"MaximumLength"=>64}
      end

      def description
        "Serial Number"
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
