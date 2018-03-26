# This is an automatically generated file, please do not modify

module Rubyhome
  class Characteristic
    class AirParticulateDensity < Characteristic
      def self.uuid
        "00000064-0000-1000-8000-0026BB765291"
      end

      def self.name
        :air_particulate_density
      end

      def constraints
        {"MaximumValue"=>1000, "MinimumValue"=>0, "StepValue"=>1}
      end

      def format
        "float"
      end

      def description
        "Air Particulate Density"
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
