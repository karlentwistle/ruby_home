# This is an automatically generated file, please do not modify

module Rubyhome
  class Characteristic
    class TargetHumidifierDehumidifierState < Characteristic
      def constraints
        {"ValidValues"=>{"0"=>"Humidifier or Dehumidifier", "1"=>"Humidifier", "2"=>"Dehumidifier"}}
      end

      def format
        "uint8"
      end

      def description
        "Target Humidifier Dehumidifier State"
      end

      def permissions
        ["securedRead", "securedWrite"]
      end

      def properties
        ["read", "write", "cnotify"]
      end

      def uuid
        "000000B4-0000-1000-8000-0026BB765291"
      end

      def unit
        nil
      end
    end
  end
end
