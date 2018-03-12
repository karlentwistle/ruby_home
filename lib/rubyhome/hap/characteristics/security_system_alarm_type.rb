# This is an automatically generated file, please do not modify

module Rubyhome
  class Characteristic
    class SecuritySystemAlarmType < Characteristic
      def constraints
        {"MaximumValue"=>1, "MinimumValue"=>0, "StepValue"=>1}
      end

      def format
        "uint8"
      end

      def description
        "Security System Alarm Type"
      end

      def permissions
        ["securedRead"]
      end

      def properties
        ["read", "cnotify"]
      end

      def uuid
        "0000008E-0000-1000-8000-0026BB765291"
      end

      def unit
        nil
      end
    end
  end
end
