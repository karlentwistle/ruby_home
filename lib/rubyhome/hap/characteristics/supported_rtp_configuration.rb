# This is an automatically generated file, please do not modify

module Rubyhome
  class Characteristic
    class SupportedRTPConfiguration < Characteristic
      def self.uuid
        "00000116-0000-1000-8000-0026BB765291"
      end

      def self.name
        :supported_rtp_configuration
      end

      def self.format
        "tlv8"
      end

      def constraints
        {}
      end

      def description
        "Supported RTP Configuration"
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
