# This is an automatically generated file, please do not modify

module Rubyhome
  class Characteristic
    class PM2_5Density < Characteristic
      def self.uuid
        "000000C6-0000-1000-8000-0026BB765291"
      end

      def self.name
        :pm2_5_density
      end

      def self.format
        "float"
      end

      def constraints
        {"MaximumValue"=>1000, "MinimumValue"=>0, "StepValue"=>1}
      end

      def description
        "PM2.5 Density"
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
