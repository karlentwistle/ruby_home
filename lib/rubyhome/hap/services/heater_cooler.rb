# This is an automatically generated file, please do not modify

module Rubyhome
  class Service
    class HeaterCooler < Service
      class << self
        def uuid
          "000000BC-0000-1000-8000-0026BB765291"
        end

        def required_characteristic_uuids
          ["000000B0-0000-1000-8000-0026BB765291", "000000B1-0000-1000-8000-0026BB765291", "000000B2-0000-1000-8000-0026BB765291", "00000011-0000-1000-8000-0026BB765291"]
        end

        def optional_characteristic_uuids
          ["000000A7-0000-1000-8000-0026BB765291", "00000023-0000-1000-8000-0026BB765291", "000000B6-0000-1000-8000-0026BB765291", "0000000D-0000-1000-8000-0026BB765291", "00000012-0000-1000-8000-0026BB765291", "00000036-0000-1000-8000-0026BB765291", "00000029-0000-1000-8000-0026BB765291"]
        end
      end

      def name
        "Heater Cooler"
      end
    end
  end
end
