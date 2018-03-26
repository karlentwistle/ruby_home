# This is an automatically generated file, please do not modify

module Rubyhome
  class Characteristic
    class FilterLifeLevel < Characteristic
      def self.uuid
        "000000AB-0000-1000-8000-0026BB765291"
      end

      def self.name
        :filter_life_level
      end

      def constraints
        {"MaximumValue"=>100, "MinimumValue"=>0, "stepValue"=>1}
      end

      def format
        "float"
      end

      def description
        "Filter Life Level"
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
