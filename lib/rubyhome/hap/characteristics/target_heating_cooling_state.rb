# This is an automatically generated file, please do not modify

module Rubyhome
  class Characteristic
    class TargetHeatingCoolingState < Characteristic
      def self.uuid
        "00000033-0000-1000-8000-0026BB765291"
      end

      def self.attribute_name
        :target_heating_cooling_state
      end

      def constraints
        {"ValidValues"=>{"0"=>"Off", "1"=>"Heat", "2"=>"Cool", "3"=>"Auto"}}
      end

      def format
        "uint8"
      end

      def description
        "Target Heating Cooling State"
      end

      def permissions
        ["securedRead", "securedWrite"]
      end

      def properties
        ["read", "write", "cnotify"]
      end

      def unit
        nil
      end
    end
  end
end
