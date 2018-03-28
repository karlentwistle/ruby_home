# This is an automatically generated file, please do not modify

module Rubyhome
  class Service
    class HumidifierDehumidifier < Service
      class << self
        def uuid
          "000000BD-0000-1000-8000-0026BB765291"
        end

        def name
          :humidifier_dehumidifier
        end

        def required_characteristic_uuids
          ["00000010-0000-1000-8000-0026BB765291", "000000B3-0000-1000-8000-0026BB765291", "000000B4-0000-1000-8000-0026BB765291", "000000B0-0000-1000-8000-0026BB765291"]
        end

        def optional_characteristic_uuids
          ["000000A7-0000-1000-8000-0026BB765291", "00000023-0000-1000-8000-0026BB765291", "000000B6-0000-1000-8000-0026BB765291", "000000B5-0000-1000-8000-0026BB765291", "000000C9-0000-1000-8000-0026BB765291", "000000CA-0000-1000-8000-0026BB765291", "00000029-0000-1000-8000-0026BB765291"]
        end
      end

      def name
        "Humidifier Dehumidifier"
      end
    end
  end
end
