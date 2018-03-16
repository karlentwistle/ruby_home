# This is an automatically generated file, please do not modify

module Rubyhome
  class Characteristic
    class StatusJammed < Characteristic
      def self.uuid
        "00000078-0000-1000-8000-0026BB765291"
      end

      def self.attribute_name
        :status_jammed
      end

      def constraints
        {"ValidValues"=>{"0"=>"Not Jammed", "1"=>"Jammed"}}
      end

      def format
        "uint8"
      end

      def description
        "Status Jammed"
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
