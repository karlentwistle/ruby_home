# This is an automatically generated file, please do not modify

module Rubyhome
  class Characteristic
    class Identify < Characteristic
      def self.uuid
        "00000014-0000-1000-8000-0026BB765291"
      end

      def self.name
        :identify
      end

      def self.format
        "bool"
      end

      def constraints
        {}
      end

      def description
        "Identify"
      end

      def permissions
        ["securedWrite"]
      end

      def properties
        ["write"]
      end

      def unit
        nil
      end
    end
  end
end
