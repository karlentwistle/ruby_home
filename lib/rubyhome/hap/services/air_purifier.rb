# This is an automatically generated file, please do not modify

module Rubyhome
  class Service
    class AirPurifier < Service
      class << self
        def uuid
          "000000BB-0000-1000-8000-0026BB765291"
        end

        def required_characteristic_uuids
          ["000000B0-0000-1000-8000-0026BB765291", "000000A9-0000-1000-8000-0026BB765291", "000000A8-0000-1000-8000-0026BB765291"]
        end

        def optional_characteristic_uuids
          ["000000A7-0000-1000-8000-0026BB765291", "00000023-0000-1000-8000-0026BB765291", "000000B6-0000-1000-8000-0026BB765291", "00000029-0000-1000-8000-0026BB765291"]
        end
      end

      def name
        "Air Purifier"
      end
    end
  end
end
