# This is an automatically generated file, please do not modify

module Rubyhome
  class Characteristic
    class ResetFilterIndication < Characteristic
      def constraints
        {"MaximumValue"=>1, "MinimumValue"=>1, "StepValue"=>1}
      end

      def format
        "uint8"
      end

      def description
        "Reset Filter Indication"
      end

      def permissions
        ["securedWrite"]
      end

      def properties
        ["write"]
      end

      def uuid
        "000000AD-0000-1000-8000-0026BB765291"
      end

      def unit
        nil
      end
    end
  end
end
