# This is an automatically generated file, please do not modify

module Rubyhome
  class Characteristic
    class ObstructionDetected < Characteristic
      def constraints
        {}
      end

      def format
        "bool"
      end

      def description
        "Obstruction Detected"
      end

      def permissions
        ["securedRead"]
      end

      def properties
        ["read", "cnotify", "uncnotify"]
      end

      def uuid
        "00000024-0000-1000-8000-0026BB765291"
      end

      def unit
        nil
      end
    end
  end
end
