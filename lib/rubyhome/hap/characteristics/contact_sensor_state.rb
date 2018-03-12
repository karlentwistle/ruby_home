# This is an automatically generated file, please do not modify

module Rubyhome
  class Characteristic
    class ContactSensorState < Characteristic
      def constraints
        {"ValidValues"=>{"0"=>"Contact Detected", "1"=>"Contact Not Detected"}}
      end

      def format
        "uint8"
      end

      def description
        "Contact Sensor State"
      end

      def permissions
        ["securedRead"]
      end

      def properties
        ["read", "cnotify", "uncnotify"]
      end

      def uuid
        "0000006A-0000-1000-8000-0026BB765291"
      end

      def unit
        nil
      end
    end
  end
end
