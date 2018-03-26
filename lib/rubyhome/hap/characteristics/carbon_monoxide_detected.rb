# This is an automatically generated file, please do not modify

module Rubyhome
  class Characteristic
    class CarbonMonoxideDetected < Characteristic
      def self.uuid
        "00000069-0000-1000-8000-0026BB765291"
      end

      def self.name
        :carbon_monoxide_detected
      end

      def constraints
        {"ValidValues"=>{"0"=>"CO Levels Normal", "1"=>"CO Levels Abnormal"}}
      end

      def format
        "uint8"
      end

      def description
        "Carbon Monoxide Detected"
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
