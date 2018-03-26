# This is an automatically generated file, please do not modify

module Rubyhome
  class Service
    class LightSensor < Service
      class << self
        def uuid
          "00000084-0000-1000-8000-0026BB765291"
        end

        def name
          :light_sensor
        end

        def required_characteristic_uuids
          ["0000006B-0000-1000-8000-0026BB765291"]
        end

        def optional_characteristic_uuids
          ["00000075-0000-1000-8000-0026BB765291", "00000077-0000-1000-8000-0026BB765291", "0000007A-0000-1000-8000-0026BB765291", "00000079-0000-1000-8000-0026BB765291", "00000023-0000-1000-8000-0026BB765291"]
        end
      end

      def name
        "Light Sensor"
      end
    end
  end
end
