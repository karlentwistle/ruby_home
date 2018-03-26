# This is an automatically generated file, please do not modify

module Rubyhome
  class Service
    class CarbonDioxideSensor < Service
      class << self
        def uuid
          "00000097-0000-1000-8000-0026BB765291"
        end

        def name
          :carbon_dioxide_sensor
        end

        def required_characteristic_uuids
          ["00000092-0000-1000-8000-0026BB765291"]
        end

        def optional_characteristic_uuids
          ["00000075-0000-1000-8000-0026BB765291", "00000077-0000-1000-8000-0026BB765291", "00000079-0000-1000-8000-0026BB765291", "0000007A-0000-1000-8000-0026BB765291", "00000093-0000-1000-8000-0026BB765291", "00000094-0000-1000-8000-0026BB765291", "00000023-0000-1000-8000-0026BB765291"]
        end
      end

      def name
        "Carbon Dioxide Sensor"
      end
    end
  end
end
