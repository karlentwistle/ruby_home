# This is an automatically generated file, please do not modify

module Rubyhome
  class Characteristic
    class Version < Characteristic
      def self.uuid
        "00000037-0000-1000-8000-0026BB765291"
      end

      def self.attribute_name
        :version
      end

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

      def unit
        nil
      end
    end
  end
end