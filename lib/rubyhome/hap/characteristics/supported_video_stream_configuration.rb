# This is an automatically generated file, please do not modify

module Rubyhome
  class Characteristic
    class SupportedVideoStreamConfiguration < Characteristic
      def self.uuid
        "00000114-0000-1000-8000-0026BB765291"
      end

      def self.name
        :supported_video_stream_configuration
      end

      def constraints
        {}
      end

      def format
        "tlv8"
      end

      def description
        "Supported Video Stream Configuration"
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
