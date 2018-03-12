# This is an automatically generated file, please do not modify

module Rubyhome
  class Characteristic
    class SelectedRTPStreamConfiguration < Characteristic
      def constraints
        {}
      end

      def format
        "tlv8"
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

      def uuid
        "00000117-0000-1000-8000-0026BB765291"
      end

      def unit
        nil
      end
    end
  end
end
