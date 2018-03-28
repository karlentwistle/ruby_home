# This is an automatically generated file, please do not modify

module Rubyhome
  class Characteristic
    class SupportedAudioStreamConfiguration < Characteristic
      def self.uuid
        "00000115-0000-1000-8000-0026BB765291"
      end

      def self.name
        :supported_audio_stream_configuration
      end

      def self.format
        "tlv8"
      end

      def constraints
        {}
      end

      def description
        "Supported Audio Stream Configuration"
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
