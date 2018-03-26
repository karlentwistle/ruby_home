# This is an automatically generated file, please do not modify

module Rubyhome
  class Characteristic
    class SulphurDioxideDensity < Characteristic
      def self.uuid
        "000000C5-0000-1000-8000-0026BB765291"
      end

      def self.name
        :sulphur_dioxide_density
      end

      def constraints
        {"MaximumValue"=>1000, "MinimumValue"=>0, "StepValue"=>1}
      end

      def format
        "float"
      end

      def description
        "Sulphur Dioxide Density"
      end

      def permissions
        ["securedRead"]
      end

      def properties
        ["read", "cnotify", "uncnotify"]
      end

      def unit
        nil
      end
    end
  end
end
