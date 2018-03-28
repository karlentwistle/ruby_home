# This is an automatically generated file, please do not modify

module Rubyhome
  class Characteristic
    class SelectedRTPStreamConfiguration < Characteristic
      def self.uuid
        "00000117-0000-1000-8000-0026BB765291"
      end

      def self.name
        :selected_rtp_stream_configuration
      end

      def self.format
        "tlv8"
      end

      def constraints
        {}
      end

      def description
        "Selected RTP Stream Configuration"
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
