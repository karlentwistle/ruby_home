# This is an automatically generated file, please do not modify

module Rubyhome
  class Service
    class LeakSensor < Service
      class << self
        def uuid
          "00000083-0000-1000-8000-0026BB765291"
        end

        def name
          :leak_sensor
        end

        def required_characteristic_uuids
          ["00000070-0000-1000-8000-0026BB765291"]
        end

        def optional_characteristic_uuids
          ["00000075-0000-1000-8000-0026BB765291", "00000077-0000-1000-8000-0026BB765291", "0000007A-0000-1000-8000-0026BB765291", "00000079-0000-1000-8000-0026BB765291", "00000023-0000-1000-8000-0026BB765291"]
        end
      end

      def name
        "Leak Sensor"
      end
    end
  end
end
