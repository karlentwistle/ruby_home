# This is an automatically generated file, please do not modify

module Rubyhome
  class Service
    class Thermostat < Service
      class << self
        def uuid
          "0000004A-0000-1000-8000-0026BB765291"
        end

        def required_characteristic_uuids
          ["0000000F-0000-1000-8000-0026BB765291", "00000033-0000-1000-8000-0026BB765291", "00000011-0000-1000-8000-0026BB765291", "00000035-0000-1000-8000-0026BB765291", "00000036-0000-1000-8000-0026BB765291"]
        end

        def optional_characteristic_uuids
          ["00000010-0000-1000-8000-0026BB765291", "00000034-0000-1000-8000-0026BB765291", "0000000D-0000-1000-8000-0026BB765291", "00000012-0000-1000-8000-0026BB765291", "00000023-0000-1000-8000-0026BB765291"]
        end
      end

      def name
        "Thermostat"
      end
    end
  end
end
