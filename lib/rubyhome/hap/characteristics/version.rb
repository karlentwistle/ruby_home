# This is an automatically generated file, please do not modify

module Rubyhome
  class Characteristic
    class Version < Characteristic
      def constraints
        {"MaximumLength"=>64}
      end

      def format
        "string"
      end

      def description
        "Version"
      end

      def permissions
        ["securedRead"]
      end

      def properties
        ["read", "cnotify"]
      end

      def uuid
        "00000037-0000-1000-8000-0026BB765291"
      end

      def unit
        nil
      end
    end
  end
end
