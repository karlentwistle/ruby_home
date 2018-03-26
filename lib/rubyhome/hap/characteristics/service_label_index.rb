# This is an automatically generated file, please do not modify

module Rubyhome
  class Characteristic
    class ServiceLabelIndex < Characteristic
      def self.uuid
        "000000CB-0000-1000-8000-0026BB765291"
      end

      def self.name
        :service_label_index
      end

      def constraints
        {"MaximumValue"=>255, "MinimumValue"=>1, "StepValue"=>1}
      end

      def format
        "uint8"
      end

      def description
        "Service Label Index"
      end

      def permissions
        ["securedRead"]
      end

      def properties
        ["read"]
      end

      def unit
        nil
      end
    end
  end
end
