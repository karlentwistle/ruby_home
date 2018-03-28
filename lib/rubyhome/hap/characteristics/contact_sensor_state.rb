# This is an automatically generated file, please do not modify

module Rubyhome
  class Characteristic
    class ContactSensorState < Characteristic
      def self.uuid
        "0000006A-0000-1000-8000-0026BB765291"
      end

      def self.name
        :contact_sensor_state
      end

      def self.format
        "uint8"
      end

      def constraints
        {"ValidValues"=>{"0"=>"Contact Detected", "1"=>"Contact Not Detected"}}
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

      def unit
        nil
      end
    end
  end
end
