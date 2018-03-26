# This is an automatically generated file, please do not modify

module Rubyhome
  class Characteristic
    class CurrentHumidifierDehumidifierState < Characteristic
      def self.uuid
        "000000B3-0000-1000-8000-0026BB765291"
      end

      def self.name
        :current_humidifier_dehumidifier_state
      end

      def constraints
        {"ValidValues"=>{"0"=>"Inactive", "1"=>"Idle", "2"=>"Humidifying", "3"=>"Dehumidifying"}}
      end

      def format
        "uint8"
      end

      def description
        "Current Humidifier Dehumidifier State"
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
