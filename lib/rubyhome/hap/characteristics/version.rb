# This is an automatically generated file, please do not modify

module Rubyhome
  class Characteristic
    class Version < Characteristic
      def self.uuid
        "00000037-0000-1000-8000-0026BB765291"
      end

      def self.name
        :version
      end

      def self.format
        "string"
      end

      def constraints
        {"MaximumLength"=>64}
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
