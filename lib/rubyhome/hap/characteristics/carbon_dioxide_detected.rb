# This is an automatically generated file, please do not modify

module Rubyhome
  class Characteristic
    class CarbonDioxideDetected < Characteristic
      def constraints
        {"ValidValues"=>{"0"=>"CO2 Levels Normal", "1"=>"CO2 Levels Abnormal"}}
      end

      def format
        "uint8"
      end

      def description
        "Carbon Dioxide Detected"
      end

      def permissions
        ["securedRead"]
      end

      def properties
        ["read", "cnotify", "uncnotify"]
      end

      def uuid
        "00000092-0000-1000-8000-0026BB765291"
      end

      def unit
        nil
      end
    end
  end
end
