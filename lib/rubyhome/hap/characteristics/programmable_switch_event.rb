# This is an automatically generated file, please do not modify

module Rubyhome
  class Characteristic
    class ProgrammableSwitchEvent < Characteristic
      def self.uuid
        "00000073-0000-1000-8000-0026BB765291"
      end

      def self.name
        :programmable_switch_event
      end

      def self.format
        "uint8"
      end

      def constraints
        {"ValidValues"=>{"0"=>"Single Press", "1"=>"Double Press", "2"=>"Long Press"}}
      end

      def description
        "Programmable Switch Event"
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
