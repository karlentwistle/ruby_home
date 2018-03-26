# This is an automatically generated file, please do not modify

module Rubyhome
  class Characteristic
    class PositionState < Characteristic
      def self.uuid
        "00000072-0000-1000-8000-0026BB765291"
      end

      def self.name
        :position_state
      end

      def constraints
        {"ValidValues"=>{"0"=>"Decreasing", "1"=>"Increasing", "2"=>"Stopped"}}
      end

      def format
        "uint8"
      end

      def description
        "Position State"
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
