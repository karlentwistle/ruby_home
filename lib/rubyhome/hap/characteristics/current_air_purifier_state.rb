# This is an automatically generated file, please do not modify

module Rubyhome
  class Characteristic
    class CurrentAirPurifierState < Characteristic
      def self.uuid
        "000000A9-0000-1000-8000-0026BB765291"
      end

      def self.name
        :current_air_purifier_state
      end

      def self.format
        "uint8"
      end

      def constraints
        {"ValidValues"=>{"0"=>"Inactive", "1"=>"Idle", "2"=>"Purifying Air"}}
      end

      def description
        "Current Air Purifier State"
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
