# This is an automatically generated file, please do not modify

module Rubyhome
  class Characteristic
    class StreamingStatus < Characteristic
      def self.uuid
        "00000120-0000-1000-8000-0026BB765291"
      end

      def self.attribute_name
        :streaming_status
      end

      def constraints
        {}
      end

      def format
        "tlv8"
      end

      def description
        "Streaming Status"
      end

      def permissions
        ["securedRead"]
      end

      def properties
        ["read", "cnotify"]
      end

      def unit
        nil
      end
    end
  end
end
