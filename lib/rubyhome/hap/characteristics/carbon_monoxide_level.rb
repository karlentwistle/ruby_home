# This is an automatically generated file, please do not modify

module Rubyhome
  class Characteristic
    class CarbonMonoxideLevel < Characteristic
      def self.uuid
        "00000090-0000-1000-8000-0026BB765291"
      end

      def self.name
        :carbon_monoxide_level
      end

      def self.format
        "float"
      end

      def constraints
        {"MaximumValue"=>100, "MinimumValue"=>0}
      end

      def description
        "Carbon Monoxide Level"
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
