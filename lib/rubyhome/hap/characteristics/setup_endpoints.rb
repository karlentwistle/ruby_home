# This is an automatically generated file, please do not modify

module Rubyhome
  class Characteristic
    class SetupEndpoints < Characteristic
      def self.uuid
        "00000118-0000-1000-8000-0026BB765291"
      end

      def self.name
        :setup_endpoints
      end

      def constraints
        {}
      end

      def format
        "tlv8"
      end

      def description
        "Setup Endpoints"
      end

      def permissions
        ["securedRead", "securedWrite"]
      end

      def properties
        ["read", "write"]
      end

      def unit
        nil
      end
    end
  end
end
